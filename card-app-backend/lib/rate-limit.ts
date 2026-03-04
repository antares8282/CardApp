import { Ratelimit } from "@upstash/ratelimit";
import { Redis } from "@upstash/redis";

const hasRedis =
  process.env.UPSTASH_REDIS_REST_URL && process.env.UPSTASH_REDIS_REST_TOKEN;

const ratelimit = hasRedis
  ? new Ratelimit({
      redis: new Redis({
        url: process.env.UPSTASH_REDIS_REST_URL!,
        token: process.env.UPSTASH_REDIS_REST_TOKEN!,
      }),
      limiter: Ratelimit.slidingWindow(10, "60 s"),
      analytics: true,
      prefix: "cardapp",
    })
  : null;

export async function checkRateLimit(
  identifier: string
): Promise<{ allowed: boolean; remaining: number }> {
  if (!ratelimit) {
    console.warn("[rate-limit] Upstash credentials not configured — skipping rate limit");
    return { allowed: true, remaining: 999 };
  }
  try {
    const { success, remaining } = await ratelimit.limit(identifier);
    return { allowed: success, remaining };
  } catch (err) {
    console.error("[rate-limit] Redis connection failed — skipping rate limit:", err);
    return { allowed: true, remaining: 999 };
  }
}
