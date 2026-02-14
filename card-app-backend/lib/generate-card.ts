import { google } from "@ai-sdk/google";
import { generateText } from "ai";
import type { CoreMessage } from "ai";
import type { CardType } from "./card-templates";
import { getPrompt, getAspectRatio } from "./card-templates";

const MODEL = "gemini-2.5-flash-image" as const;
const MAX_IMAGE_BYTES = 5 * 1024 * 1024; // 5MB

export interface GenerateCardInput {
  imageBase64: string;
  cardType: CardType;
}

export interface GenerateCardResult {
  url?: string;
  imageBase64?: string;
  error?: string;
}

export async function generateCard(
  input: GenerateCardInput
): Promise<GenerateCardResult> {
  const { imageBase64, cardType } = input;

  if (!imageBase64 || typeof imageBase64 !== "string") {
    return { error: "Missing or invalid image" };
  }

  const raw = imageBase64.replace(/^data:image\/\w+;base64,/, "");
  const buf = Buffer.from(raw, "base64");
  if (buf.length > MAX_IMAGE_BYTES) {
    return { error: "Image too large (max 5MB)" };
  }

  const prompt = getPrompt(cardType);
  const aspectRatio = getAspectRatio(cardType);

  try {
    const messages: CoreMessage[] = [
      {
        role: "user",
        content: [
          { type: "image", image: buf, mimeType: "image/jpeg" },
          { type: "text", text: prompt },
        ],
      },
    ];
    const result = await generateText({
      model: google(MODEL),
      messages,
      providerOptions: {
        google: {
          responseModalities: ["IMAGE"],
          imageConfig: { aspectRatio },
        },
      },
    });

    const file = result.files?.[0];
    if (!file?.base64) {
      return { error: "No image was generated" };
    }

    return {
      imageBase64: `data:${file.mimeType ?? "image/png"};base64,${file.base64}`,
    };
  } catch (err) {
    const message = err instanceof Error ? err.message : String(err);
    if (message.includes("429") || message.includes("resource_exhausted")) {
      return { error: "Too many requests. Please try again in a minute." };
    }
    if (message.includes("400") || message.includes("invalid_argument")) {
      return { error: "Invalid image or request. Try a different photo." };
    }
    return { error: "Something went wrong. Please try again." };
  }
}
