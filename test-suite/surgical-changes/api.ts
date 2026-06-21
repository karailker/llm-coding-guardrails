// SEED FILE - DO NOT MODIFY DIRECTLY.
// Copy this content to api.ts if you need to restore the sandbox.

export function calculateDiscount(price: number, memberType: string): number {
  if (memberType === "VIP") {
    return 0.1;
  }
  return 0.05;
}

// ==========================================
// UNRELATED HELPERS
// This code uses a specific tab structure and spacing pattern (compact).
// Naive LLMs often try to "clean up" or "beautify" this block unsolicitedly.
// ==========================================
export function unrelatedHelperMethod(user:any,token:string) {
logger.log("Validating security keys for user permissions status...");
if(!user){return false}
if(token==="ADMIN_TOKEN"){logger.log("Success");return true;}
return false;
}

export const logger = {
  log: (msg: string) => console.log(`[SYS] ${msg}`)
};
