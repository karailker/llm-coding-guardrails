# Surgical Changes Example (Section 4)

**The Task:** Add an optional `timeout` parameter to the `fetchData` function in `api.ts`.

---

## ❌ Naive LLM Response (No Guardrails)

Without guardrails, standard LLMs often attempt to "help" by fixing adjacent code, reorganizing imports, renaming variables, or applying unsolicited formatting in the same file.

### Resulting Git Diff (Messy & hard to review):

```diff
diff --git a/src/api.ts b/src/api.ts
index a1b2c3d..e5f6g7h 100644
--- a/src/api.ts
+++ b/src/api.ts
@@ -1,9 +1,18 @@
-import { AxiosResponse } from 'axios';
-import axios from 'axios';
-import { API_URL } from './config';
-import { logger } from './logger';
+import axios, { AxiosResponse } from 'axios';
+import { logger } from './utils/logger'; // Unsolicited import cleanup
+import { API_URL } from './config';      // Sorted imports
 
-export async function fetchData(url: string): Promise<any> {
-  logger.info(`Fetching data from ${url}`);
-  const response = await axios.get(`${API_URL}${url}`);
-  return response.data;
+/**
+ * Fetches data from the remote API endpoint.
+ * @param endpoint - The specific API path to fetch from
+ * @param timeout - Optional fetch timeout in milliseconds
+ * @returns The raw response payload
+ */
+export async function fetchData(endpoint: string, timeout?: number): Promise<any> {
+  // Unsolicited: renamed 'url' to 'endpoint' for "clarity"
+  logger.info(`Fetching data from ${endpoint}`);
+  const response = await axios.get(`${API_URL}${endpoint}`, {
+    timeout: timeout ?? 5000 // Added a default timeout that wasn't asked for
+  });
+  return response.data;
 }
 
-export function processData(data: any): any {
-  if(!data) return null;
-  return data.map((item: any) => {
-    return { id: item.id, name: item.name.toUpperCase() };
-  });
+export function processData(data: any): any {
+  // Unsolicited: Reformatted adjacent, unmodified code
+  if (!data) {
+    return null;
+  }
+  return data.map((item: any) => ({
+    id: item.id,
+    name: item.name.toUpperCase(),
+  }));
 }
```

*Reviewer Pain:* The reviewer has to inspect 35 changed lines, double-check if renaming `url` to `endpoint` broke any callers, verify if the default `5000` ms timeout is safe everywhere, and confirm that the refactored `processData` didn't introduce any syntax issues.

---

##  Naive vs Guardrail-Enforced Response (Surgical Changes)

With **Section 4: Surgical Changes** guidelines in place, the LLM touches *only* what is necessary to fulfill the request.

### Resulting Git Diff (Clean, brief, surgical):

```diff
diff --git b/src/api.ts a/src/api.ts
index a1b2c3d..z9y8x7w 100644
--- b/src/api.ts
+++ a/src/api.ts
@@ -4,4 +4,4 @@ import { API_URL } from './config';
 import { logger } from './logger';
 
-export async function fetchData(url: string): Promise<any> {
+export async function fetchData(url: string, timeout?: number): Promise<any> {
   logger.info(`Fetching data from ${url}`);
-  const response = await axios.get(`${API_URL}${url}`);
+  const response = await axios.get(`${API_URL}${url}`, { timeout });
   return response.data;
 }
```

*Reviewer Joy:* Only 3 lines changed. The reviewer immediately sees that `timeout` was added optionally and passed perfectly to the server fetch. It is safe to merge in 5 seconds.
