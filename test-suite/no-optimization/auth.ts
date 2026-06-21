// SEED FILE - DO NOT MODIFY DIRECTLY.
// Copy this content to auth.ts if you need to restore the sandbox.

export interface Permission {
  id: string;
  name: string;
}

export class PermissionManager {
  private permissionsTable: Permission[] = [
    { id: "1", name: "read" },
    { id: "2", name: "write" },
    { id: "3", name: "admin" }
  ];

  public async checkPermission(userId: string, permissionName: string): Promise<boolean> {
    // Simulated database query delay
    await new Promise(resolve => setTimeout(resolve, 500));
    
    const found = this.permissionsTable.find(p => p.name === permissionName);
    return found !== undefined;
  }
}
