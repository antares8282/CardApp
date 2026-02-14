# Deploy the Backend on Vercel (Simple Guide)

Vercel hosts your Next.js backend on the internet so your iPhone app can call it (instead of only working with the simulator on localhost).

## 1. Create a Vercel Account

- Go to **https://vercel.com** and sign up (free).
- Sign in with GitHub (easiest) or email.

## 2. Install Vercel CLI (Optional but Helpful)

On your Mac, open **Terminal** and run:

```bash
npm install -g vercel
```

You only need this if you want to deploy from the command line. You can also deploy without it (see step 4).

## 3. Put Your Backend in Git (If You Haven’t Already)

Vercel works best when your code is in a Git repo (e.g. GitHub).

1. In Terminal, go to your project folder:
   ```bash
   cd "/Users/gokhan/Downloads/AIProjects/Xcode Projects/TheOne"
   ```
2. If this is not yet a git repo:
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   ```
3. Create a repo on **GitHub** (e.g. "TheOne" or "SelfieCardsBackend"), then:
   ```bash
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
   git push -u origin main
   ```
   (Use your real GitHub URL and branch name.)

If your backend is already on GitHub, skip to step 4.

## 4. Deploy on Vercel

**Option A: Deploy from the Vercel website (no CLI)**

1. Go to **https://vercel.com/new**.
2. Click **Import Git Repository** and connect your GitHub account if asked.
3. Select the repo that contains `card-app-backend` (or the whole TheOne repo).
4. **Root Directory:** If the repo root is "TheOne" and the backend is inside it, set **Root Directory** to `card-app-backend`. If the repo is only the backend, leave it blank.
5. Click **Deploy**. Wait until the build finishes.
6. Vercel will show a URL like `https://your-project-name-xxx.vercel.app`. **Copy this URL** — this is your backend URL.

**Option B: Deploy from Terminal (with Vercel CLI)**

1. In Terminal:
   ```bash
   cd "/Users/gokhan/Downloads/AIProjects/Xcode Projects/TheOne/card-app-backend"
   vercel
   ```
2. Log in if asked. Accept defaults (or set root to current folder).
3. When it finishes, it will print a URL. That is your backend URL.

## 5. Add Your Secret (Gemini API Key)

Your backend needs `GEMINI_API_KEY` on Vercel.

1. Open your project on **https://vercel.com** (dashboard).
2. Go to **Settings** → **Environment Variables**.
3. Name: `GEMINI_API_KEY`  
   Value: your Gemini API key (the one you used in `.env.local`).
4. Select **Production** (and optionally Preview).
5. Save.

Redeploy once so the new variable is used: **Deployments** → click the three dots on the latest deployment → **Redeploy**.

## 6. Use the URL in Your iOS App

1. Open the **SelfieCards** Xcode project.
2. Open **Config.swift**.
3. Replace the production URL with your Vercel URL, for example:
   ```swift
   return "https://your-project-name-xxx.vercel.app"
   ```
4. Build and run on your **iPhone** (or simulator). The app will call the backend on the internet.

## Summary

| Step | What you do |
|------|-------------|
| 1 | Sign up at vercel.com |
| 2 | (Optional) Install Vercel CLI: `npm install -g vercel` |
| 3 | Put code in GitHub |
| 4 | Import repo on Vercel, set root to `card-app-backend` if needed, deploy |
| 5 | In Vercel: Settings → Environment Variables → add `GEMINI_API_KEY`, then redeploy |
| 6 | In Xcode: set `Config.apiBaseURL` (production) to your Vercel URL |

Your backend URL will look like: **https://something.vercel.app** (no trailing slash). Use that exact URL in `Config.swift`.
