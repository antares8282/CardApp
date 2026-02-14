# Card App Backend

Next.js API for the Selfie Cards app. Generates greeting cards from a selfie using Gemini (Nano Banana) image generation.

## Setup

1. Install: `npm install`
2. Ensure `.env.local` contains `GEMINI_API_KEY=your_key`
3. Run: `npm run dev` → server at http://localhost:3000

## API

**POST** `/api/generate-card`

Body (JSON):

- `imageBase64` (string): base64-encoded image (with or without `data:image/...;base64,` prefix)
- `cardType` (string): `christmas` | `birthday` | `valentines`

Response:

- `imageBase64`: data URL of the generated card image
- `url`: optional blob URL if storage is configured
- `error`: present on failure

Rate limit: 10 requests per minute per IP.
