import { NextRequest, NextResponse } from "next/server";
import { checkRateLimit } from "@/lib/rate-limit";
import { generateCard } from "@/lib/generate-card";
import type { CardType } from "@/lib/card-templates";

export const maxDuration = 60;

const VALID_CARD_TYPES: CardType[] = ["christmas", "birthday", "valentines"];

function getClientId(req: NextRequest): string {
  const forwarded = req.headers.get("x-forwarded-for");
  if (forwarded) return forwarded.split(",")[0].trim();
  const host = req.headers.get("x-real-ip");
  if (host) return host;
  return "anonymous";
}

export async function POST(req: NextRequest) {
  try {
    const clientId = getClientId(req);
    const { allowed, remaining } = checkRateLimit(clientId);
    if (!allowed) {
      return NextResponse.json(
        { error: "Too many requests. Please try again in a minute." },
        { status: 429, headers: { "X-RateLimit-Remaining": "0" } }
      );
    }

    const body = await req.json();
    const { imageBase64, cardType } = body;

    if (!cardType || !VALID_CARD_TYPES.includes(cardType)) {
      return NextResponse.json(
        { error: "Invalid card type. Use christmas, birthday, or valentines." },
        { status: 400 }
      );
    }

    const result = await generateCard({
      imageBase64: imageBase64 ?? "",
      cardType: cardType as CardType,
    });

    if (result.error) {
      const status = result.error.includes("Too many requests") ? 429 : 400;
      return NextResponse.json({ error: result.error }, { status });
    }

    return NextResponse.json({
      url: result.url,
      imageBase64: result.imageBase64,
      error: result.error,
    });
  } catch (e) {
    return NextResponse.json(
      { error: "Something went wrong. Please try again." },
      { status: 500 }
    );
  }
}
