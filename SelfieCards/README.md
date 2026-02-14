# Selfie Cards (iOS)

iOS app for the Selfie-to-Card flow. Uses the backend in `card-app-backend` for Gemini image generation.

## Open the project in Xcode

1. In **Finder**, go to:  
   `TheOne/SelfieCards/`
2. Double‑click **SelfieCards.xcodeproj** (the Xcode project).
3. Xcode will open. Select the **SelfieCards** scheme and a simulator (e.g. iPhone 15), then press **Run** (or Cmd+R).

The project already includes all Swift files and Info.plist. No need to create a new project manually.

## Backend: local (simulator) vs Vercel (device)

- **Simulator:** The app is set to use `http://localhost:3000`. Start the backend on your Mac:
  ```bash
  cd card-app-backend
  npm run dev
  ```
  Then run the app in the simulator.

- **Real iPhone or when you can’t use localhost:** Deploy the backend to **Vercel** and put that URL in the app. Step‑by‑step is in:
  - **card-app-backend/VERCEL_GUIDE.md**

  After deploying, open **Config.swift** in Xcode and set the production URL to your Vercel URL (e.g. `https://your-app.vercel.app`).

## Run (simulator)

1. Start backend: `cd card-app-backend && npm run dev`
2. Open **SelfieCards.xcodeproj** in Xcode → Run (Cmd+R).
3. In the app: choose a selfie → pick a card type → tap “Create my card”.
