# Phoenix Forge: how the site works

- **Live site:** https://phoenixforgeknives.netlify.app
- **Editor:** https://phoenixforgeknives.netlify.app/admin (or the "Editor login" link at the bottom of the site)
- **Code and content:** GitHub repo `Jmckinsey/phoenix-forge`
- **Hosting:** Netlify project `phoenixforgeknives`. It rebuilds automatically on every change.
- **Editor logins:** DecapBridge. Invite or remove editors under **Manage collaborators**.

## For Jim: using the editor

**Add a knife:** **Knives → + Knife**. Fill in the name, type, photos, summary, specs, story, steps and details, then click **Publish → Publish now**. It appears on the site, with its own page and QR code, in about a minute.

**Write a journal post:** **Journal → + Journal post**. Fill in the title, date (**Now** = today), text and photos. Optionally pick a related knife. Then click **Publish → Publish now**.

**Edit or delete:** click any knife or post in the list. Delete is in the **Publish** menu (the arrow next to Publish).

**About text and settings:** **Site settings**. Turn off **Show setup hints** once real content is in. That hides the gray hint boxes and the example post.

Tips:

- The first photo is the cover. Drag photos to reorder them.
- Phone photos work, but resizing to about 2000 px wide makes the site faster.
- New knives show first. To pin a knife in place, give it a **Display order** number: 1 shows first, then 2, and so on.

## For Jake: how it fits together

- Each knife is saved as its own file in `content/knives/`, and each post in `content/posts/`.
- On every publish, Netlify runs `node build.js` (set in `netlify.toml`). It combines those files into `data/knives.json` and `data/posts.json`, which the page reads.
- The About text and settings are in `data/site.json`.
- Photos are saved to `images/uploads/`.
- Editor settings are in `admin/config.yml`. The `backend:` block comes from DecapBridge.
- **GitHub token:** DecapBridge saves through a fine-grained token with Contents read/write on this repo only. If it expires, the editor stops saving. Make a new token and paste it into DecapBridge → Settings.

## QR codes

- Every knife page has a QR code and a **Download QR** button, which saves a labeled PNG you can print.
- Renaming a knife changes its address, so print a new code for that knife.
- If you move to a custom domain, put it in **Site settings → Site web address** and print new codes.

## Custom domain (optional, about $10–20 a year)

1. Buy a name such as `phoenixforge.com` at Cloudflare, Porkbun or Namecheap.
2. In Netlify, go to **Domain management → Add a domain**.
3. Update the login URL in DecapBridge site settings to the new address.
4. Update `site_url` and `display_url` in `admin/config.yml`.
