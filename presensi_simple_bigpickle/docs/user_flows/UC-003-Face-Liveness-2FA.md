# UC-003: Face Liveness Detection 2FA

**Actors:** Siswa (subject), System (processor)

**Main Flow:**
1. After barcode verified, Siswa proceeds to biometric verification
2. System captures eye landmarks → computes EAR (Eye Aspect Ratio)
3. If EAR > 0.2 sustained for ≥ 0.15s → liveness passed
4. System sends challenge-response (random blink pattern)
5. If step 3 + 4 passed → `BiometricAttempt.hasil_akhir = "Sukses"`
6. `AttendanceRecord.status_verifikasi` updated to `"Terverifikasi"`
7. Full attendance recorded

**Alternative Flow (EAR ≤ 0.2):**
- Liveness failed → `Count_fail += 1`
- BiometricAttempt.hasil_akhir = "Gagal"
- If Count_fail < 3 → Siswa can retry
- If Count_fail ≥ 3 → Freeze State activated:
  - `FreezeState.status_freeze = true`
  - `User.status_akun = "Freeze"`
  - Siswa locked out → must visit Admin IT for physical unfreeze

**Exception Flow (Frozen Account):**
- Biometric page renders "Akun Difreeze — hubungi Admin IT" overlay
- No further attempts allowed
