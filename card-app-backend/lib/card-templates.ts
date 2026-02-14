export type CardType = "christmas" | "birthday" | "valentines";

export const CARD_TEMPLATES: Record<
  CardType,
  { prompt: string; aspectRatio: "4:3" | "1:1" }
> = {
  christmas: {
    prompt:
      "Create a festive Christmas greeting card. Integrate this person's face/photo naturally and seamlessly into the design. The card should show a warm, celebratory holiday scene (e.g. winter, snow, ornaments, or 'Merry Christmas' message). The person should look like they belong in the scene. Output only the card image, professional and suitable for sending.",
    aspectRatio: "4:3",
  },
  birthday: {
    prompt:
      "Create a cheerful Happy Birthday greeting card. Integrate this person's face/photo naturally and seamlessly into the design. The card should feel celebratory (e.g. balloons, cake, confetti, or 'Happy Birthday' message). The person should look like they belong in the scene. Output only the card image, professional and suitable for sending.",
    aspectRatio: "4:3",
  },
  valentines: {
    prompt:
      "Create a romantic Happy Valentine's Day greeting card. Integrate this person's face/photo naturally and seamlessly into the design. The card should feel warm and romantic (e.g. hearts, roses, or 'Happy Valentine\'s Day' message). The person should look like they belong in the scene. Output only the card image, professional and suitable for sending.",
    aspectRatio: "4:3",
  },
};

export function getPrompt(cardType: CardType): string {
  return CARD_TEMPLATES[cardType].prompt;
}

export function getAspectRatio(cardType: CardType): "4:3" | "1:1" {
  return CARD_TEMPLATES[cardType].aspectRatio;
}
