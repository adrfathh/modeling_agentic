# SYS-UC-005: Freeze/Unfreeze — Admin IT Physical Verification Only

## Freeze (Automatic)
- Trigger: `Count_fail ≥ 3` on biometric attempts
- System action: lock account
- No manual freeze by any role

## Unfreeze (Manual — Admin IT Only)
- **NO remote unfreeze allowed**
- Admin IT must:
  1. Verify student identity card (KTP/SIM/Kartu Pelajar)
  2. Verify bound device physically matches record
  3. Confirm hardware binding is still valid
- Only then can Admin IT execute unfreeze in system

## System Enforcement
- Unfreeze endpoint checks `role === "admin_it"` before processing
- Non-admin role calls to unfreeze → 403 Forbidden
- Audit log records: "Unfreeze akun siswa_id=X oleh Admin IT (verifikasi fisik)"
