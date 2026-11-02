# Phoenix Forge: setup guide

The site has two parts:

- **The website** (`index.html`): what visitors see.
- **The editor** (`/admin`): where Jim signs in to add knives, photos, journal posts and the About text. No code to edit.

Everything he saves in the editor goes into a GitHub repository. Netlify sees the change and updates the live site within about a minute.

All of this is free. It takes about 30 minutes, and you only do it once.

---

## 1. Put the files on GitHub

1. Make a free account at https://github.com if you don't have one.
2. Click **+ → New repository**. Name it `phoenix-forge`, set it to **Public** or **Private**, and click **Create repository**.
3. On the new repo page, click **uploading an existing file**.
4. Drag in **everything inside** the `phoenix-forge` folder: `index.html`, `SETUP.md`, and the `admin`, `data` and `images` folders. Click **Commit changes**.
   - GitHub skips empty folders. That's fine, because `images/uploads` gets created the first time a photo is uploaded.
5. (Already done: `admin/config.yml` is set to `Jmckinsey/phoenix-forge`.)
   ```
   repo: YOUR-GITHUB-USERNAME/phoenix-forge
   ```
   to your actual username, for example `repo: jakemckinsey/phoenix-forge`. Commit the change.

## 2. Connect Netlify to GitHub

1. Go to https://app.netlify.com and sign up with your GitHub account.
2. Click **Add new project → Import an existing project → GitHub**, then pick `phoenix-forge`.
3. Leave **Build command** empty and set **Publish directory** to `.` (a single dot). Click **Deploy**.
4. Under **Project configuration → Change project name**, rename it to something like `phoenixforge`. The site address becomes `phoenixforge.netlify.app`.

If you used Netlify drag-and-drop before, delete that old project. This one replaces it.

## 3. Turn on "Login with GitHub" for the editor

1. On GitHub, go to https://github.com/settings/developers → **OAuth Apps → New OAuth App**.
   - **Application name:** Phoenix Forge Editor
   - **Homepage URL:** your Netlify address, e.g. `https://phoenixforge.netlify.app`
   - **Authorization callback URL:** `https://api.netlify.com/auth/done`
2. Click **Register**, then **Generate a new client secret**. Copy the **Client ID** and **Client Secret**. GitHub only shows the secret once.
3. In Netlify, go to your project → **Project configuration → Security → OAuth → Install provider → GitHub**. Paste the ID and secret, then save.

## 4. Give Jim access

1. Jim makes his own free GitHub account.
2. In the repo on GitHub, go to **Settings → Collaborators → Add people** and invite his username. He accepts the email invite.
3. Jim goes to **yoursite.netlify.app/admin** and clicks **Login with GitHub**.

You can sign in the same way to help him.

## 5. Using the editor

The editor has three sections:

- **Journal:** click **Add post**, then fill in the title, date (**Now** = today), tag, an optional related knife, photos and text. Click **Publish → Publish now**.
- **Knives:** add, edit, reorder or remove knives. Each knife has photos, specs, story, how it was made, and details.
- **Site settings:** edit the About text. Turn off **Show setup hints** once real content is in. That hides the gray hint boxes and the example post.

After publishing, the live site updates in about a minute. Refresh the page to see it.

Photo tips:

- Phone photos work, but large ones load slowly. Resizing to about 2000 px on the long side before uploading helps.
- The first photo is the cover. Drag photos to reorder them.

## QR codes

- Every knife page has a QR code and a **Download QR** button, which saves a labeled PNG you can print.
- Print codes only after the site has its final address.
- If you move to a custom domain later, add it in **Site settings → Site web address** and print new codes.
- Renaming a knife changes its page address, so print a new code for that knife too.

## Custom domain (optional, about $10–20 a year)

1. Buy a name such as `phoenixforge.com` at Cloudflare, Porkbun or Namecheap.
2. In Netlify, go to **Domain management → Add a domain** and follow the steps.
3. Update the **Homepage URL** in the GitHub OAuth app to match. The callback URL stays the same.

## Editing by hand (optional)

All content lives in `data/knives.json`, `data/posts.json` and `data/site.json`. You can edit them directly on GitHub. The editor is just a friendlier way to change the same files.

To preview the site on your own computer, run a local web server in the folder, for example `python -m http.server`, then open http://localhost:8000. Double-clicking `index.html` won't load the content.
