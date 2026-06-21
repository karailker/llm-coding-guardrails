# No Optimization Without Proof Example (Section 5)

**The Task:** "The user permission check in our authentication middleware seems slow. Optimize the `checkPermission` method to make it faster."

---

## ❌ Naive LLM Response (No Guardrails)

Without empirical constraints, standard LLMs will jump straight to adding complex memoization, caching, or custom data structures based on pure intuition. This often results in "over-engineering" that increases complexity, memory footprint, and bugs.

### Response snippet:

```typescript
// Naive AI jumps to implementing a custom, complex TTL-based memory cache.
import { Redis } from 'redis'; // Unrequested new dependency!

export class PermissionManager {
  private localCache = new Map<string, { value: boolean; expiresAt: number }>();
  private cacheTtlMs = 60000; // Hardcoded guess of 60 seconds

  async checkPermission(userId: string, permission: string): Promise<boolean> {
    const cacheKey = `${userId}:${permission}`;
    const cached = this.localCache.get(cacheKey);

    if (cached && cached.expiresAt > Date.now()) {
      return cached.value;
    }

    // Speculative optimization: what if DB is down? Let's add extra fallback Redis check too...
    const redisVal = await Redis.get(cacheKey); 
    if (redisVal !== null) {
      const hasPerm = redisVal === 'true';
      this.localCache.set(cacheKey, { value: hasPerm, expiresAt: Date.now() + this.cacheTtlMs });
      return hasPerm;
    }

    const hasPermission = await db.query('SELECT 1 FROM permissions WHERE user_id = ? AND name = ?', [userId, permission]);
    const result = hasPermission.length > 0;
    
    this.localCache.set(cacheKey, { value: result, expiresAt: Date.now() + this.cacheTtlMs });
    return result;
  }
}
```

### Resulting Problems:
1. **Unneeded Dependencies:** Introduced a Redis connection dependency out of nowhere.
2. **Memory Leak Risk:** The local `Map` grows indefinitely without any eviction policy or garbage collection cleanup.
3. **Stale State Bug:** Permissions changes aren't synchronized—users who get their permissions revoked still have access for 60 seconds.
4. **Intuition Fallacy:** Is the database query actually the bottleneck? If the table is properly indexed on `(user_id, name)`, the query takes $< 1\text{ ms}$, and the real latency was actually a slow network roundtrip to the server itself that caching at this layer won't solve.

---

##  Naive vs Guardrail-Enforced Response (No Optimization Without Proof)

With **Section 5: No Optimization Without Proof** guidelines in place, the LLM prevents premature optimization. It steps back, asks for measurement, and suggests starting with factual evidence.

### Response snippet:

> **I would be glad to help make the permission checking faster! However, according to our project guidelines, we do not optimize code or resource usage based on assumption or intuition. Before we write caching or complex query layers, we must measure the baseline reality first.**
>
> To proceed surgically and build the simplest solution:
> 1. Do we have profiling data, APM metrics (such as Datadog or OpenTelemetry), or database query plans (`EXPLAIN ANALYZE`) showing that the SQL query is indeed our bottleneck?
> 2. If no metrics are available yet, I can assist you in writing a simple telemetry wrapper to measure the `checkPermission` latency and log database execution times, so we can isolate whether the cost resides in the database execution, network roundtrip, or server thread pooling.
> 3. Once we have a measured baseline, we can discuss concrete caching or index options with clear expected gains.
>
> Would you like to start by adding a fast telemetry tracer to measure the current performance?

*Why this is a Senior response:* Instead of introducing a complex cache that leaks memory and allows stale permissions, the AI ensures changes are driven by data. It protects the codebase from unnecessary runtime state and bugs.
