#!/usr/bin/env bash
# Phoenix Forge: set up a Raspberry Pi to host the site.
# Run on the Pi:  bash setup-pi.sh
# - Installs nginx, git and Node
# - Downloads the site from GitHub into /srv/phoenix-forge
# - Serves it on http://localhost:8080 (Cloudflare Tunnel puts it on the internet)
# - Checks GitHub every minute and rebuilds when Jim publishes something
set -euo pipefail

REPO="https://github.com/Jmckinsey/phoenix-forge.git"
DIR="/srv/phoenix-forge"
ME="$(whoami)"

echo "==> Installing software (this takes a few minutes)"
sudo apt-get update -y
sudo apt-get install -y git nginx nodejs

echo "==> Downloading the site"
sudo mkdir -p "$DIR"
sudo chown "$ME:$ME" "$DIR"
if [ ! -d "$DIR/.git" ]; then
  git clone "$REPO" "$DIR"
fi
cd "$DIR"
node build.js

echo "==> Setting up the web server"
sudo tee /etc/nginx/sites-available/phoenix-forge >/dev/null <<EOF
server {
  listen 127.0.0.1:8080;
  root $DIR;
  index index.html;
  absolute_redirect off;

  location ~ /\.git { deny all; }
  location = /admin { return 301 /admin/; }
  location / { try_files \$uri \$uri/ =404; }

  # Always check for new content; cache photos for a week
  location ~* \.(html|json|yml)$ { add_header Cache-Control "no-cache"; try_files \$uri =404; }
  location ~* \.(jpg|jpeg|png|webp|gif)$ { expires 7d; try_files \$uri =404; }
}
EOF
sudo ln -sf /etc/nginx/sites-available/phoenix-forge /etc/nginx/sites-enabled/phoenix-forge
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl enable --now nginx
sudo systemctl reload nginx

echo "==> Setting up automatic updates from GitHub"
sudo tee /usr/local/bin/phoenix-forge-update >/dev/null <<'EOF'
#!/usr/bin/env bash
# Pull the latest site from GitHub and rebuild if anything changed.
set -e
cd /srv/phoenix-forge
git fetch -q origin main
if [ "$(git rev-parse HEAD)" != "$(git rev-parse origin/main)" ] || [ "${1:-}" = "--force" ]; then
  git reset -q --hard origin/main
  node build.js
  echo "Updated to $(git rev-parse --short HEAD)"
fi
EOF
sudo chmod +x /usr/local/bin/phoenix-forge-update

sudo tee /etc/systemd/system/phoenix-forge-update.service >/dev/null <<EOF
[Unit]
Description=Update Phoenix Forge site from GitHub
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
User=$ME
ExecStart=/usr/local/bin/phoenix-forge-update
EOF

sudo tee /etc/systemd/system/phoenix-forge-update.timer >/dev/null <<'EOF'
[Unit]
Description=Check GitHub for Phoenix Forge updates every minute

[Timer]
OnBootSec=30s
OnUnitActiveSec=60s

[Install]
WantedBy=timers.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable --now phoenix-forge-update.timer

echo
echo "==> Checking"
if curl -fsS http://127.0.0.1:8080/ | grep -q "Phoenix Forge"; then
  echo "OK: the site is running on this Pi at http://127.0.0.1:8080"
  echo "Knives on the site: $(node -e 'console.log(require("/srv/phoenix-forge/data/knives.json").knives.length)')"
else
  echo "Something went wrong: the site did not respond. Send this output to Claude."
fi
