# SYS-UC-003: EAR-based Liveness Detection + Freeze State

## EAR Computation
- Input: 6 eye landmarks `[p1, p2, p3, p4, p5, p6]`
- Formula: `EAR = (||p2-p6|| + ||p3-p5||) / (2 * ||p1-p4||)`
- Threshold: `EAR > 0.2` sustained for `≥ 0.15s` = LIVENESS PASSED
- If EAR ≤ 0.2 = LIVENESS FAILED

## Challenge-Response
- System sends random blink pattern (e.g., "Blink 2x dalam 3 detik")
- Student must match pattern
- If pattern matched + EAR passed → full liveness confirmed

## Count_fail Tracking
- Each failed attempt increments `FreezeState.count_fail`
- `FreezeState` created on first fail if not exists
- Counter persists across sessions

## Freeze State (Count_fail ≥ 3)
- `FreezeState.status_freeze = true`
- `FreezeState.waktu_freeze = NOW`
- `User.status_akun = "Freeze"`
- All attendance endpoints return error for frozen user
- Biometric page blocked with freeze overlay

## Unfreeze (Admin IT only, physical verification)
- `FreezeState.status_freeze = false`
- `FreezeState.waktu_unfreeze = NOW`
- `FreezeState.count_fail = 0`
- `User.status_akun = "Aktif"`
