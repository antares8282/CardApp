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

## 3. Put Your Backend in Git (If You Haven't Already)

Vercel works best when your code is in a Git repo (e.g. GitHub).

1. In Terminal, go to your project folder:
   ```bash
   cd "/Users/gokhan/Downloads/AIProjects/Xcode Projects/CardApp"
   ```
2. If this is not yet a git repo:
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   ```
3. Create a repo on **GitHub**, then:
   ```bash
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
   git push -u origin main
   ```

If your backend is already on GitHub, skip to step 4.

## 4. Create Upstash Redis (Free — for Rate Limiting)

Your backend needs a shared database to track rate limits. Upstash Redis is a free cloud service that handles this.

1. Go to **https://console.upstash.com** and sign up (free).
2. Click **Create Database**.
3. Pick a name (e.g. "cardapp") and a region close to your Vercel deployment (e.g. US-East-1).
4. Once created, you'll see a details page. Copy these two values:
   - **UPSTASH_REDIS_REST_URL** (looks like `https://something.upstash.io`)
   - **UPSTASH_REDIS_REST_TOKEN** (a long string starting with `AX...`)
5. You'll paste these into Vercel in the next step.

**Why do I need this?** Without it, your rate limiter doesn't work on Vercel. Each serverless function starts fresh — an in-memory counter resets every time. Upstash gives all function instances a shared counter.

**Cost:** Free tier = 10,000 commands/day. Each card generation uses ~3 commands. You'd need 3,000+ cards/day to exceed this.

## 5. Deploy on Vercel

**Option A: Deploy from the Vercel website (no CLI)**

1. Go to **https://vercel.com/new**.
2. Click **Import Git Repository** and connect your GitHub account if asked.
3. Select the repo that contains `card-app-backend`.
4. **Root Directory:** Set to `card-app-backend`.
5. Click **Deploy**. Wait until the build finishes.
6. Vercel will show a URL like `https://your-project-name-xxx.vercel.app`. **Copy this URL** — this is your backend URL.

**Option B: Deploy from Terminal (with Vercel CLI)**

1. In Terminal:
   ```bash
   cd "/Users/gokhan/Downloads/AIProjects/Xcode Projects/CardApp/card-app-backend"
   vercel
   ```
2. Log in if asked. Accept defaults (or set root to current folder).
3. When it finishes, it will print a URL. That is your backend URL.

## 6. Add Your Environment Variables

Your backend needs 3 secret values on Vercel.

1. Open your project on **https://vercel.com** (dashboard).
2. Go to **Settings** > **Environment Variables**.
3. Add these three:

| Name | Value | Where to get it |
|------|-------|-----------------|
| `GEMINI_API_KEY` | Your Gemini API key | Google AI Studio |
| `UPSTASH_REDIS_REST_URL` | `https://something.upstash.io` | Upstash dashboard (step 4) |
| `UPSTASH_REDIS_REST_TOKEN` | `AXxx...` | Upstash dashboard (step 4) |

4. Select **Production** (and optionally Preview) for each.
5. Save.

Redeploy once so the new variables are used: **Deployments** > click the three dots on the latest deployment > **Redeploy**.

## 7. Use the URL in Your iOS App

1. Open the **SelfieCards** Xcode project.
2. Open **Config.swift**.
3. Replace the production URL with your Vercel URL:
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
| 4 | Create free Upstash Redis database, copy URL + Token |
| 5 | Import repo on Vercel, set root to `card-app-backend`, deploy |
| 6 | In Vercel: Settings > Environment Variables > add `GEMINI_API_KEY`, `UPSTASH_REDIS_REST_URL`, `UPSTASH_REDIS_REST_TOKEN`, then redeploy |
| 7 | In Xcode: set `Config.apiBaseURL` (production) to your Vercel URL |

Your backend URL will look like: **https://something.vercel.app** (no trailing slash). Use that exact URL in `Config.swift`.
