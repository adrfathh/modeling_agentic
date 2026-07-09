# UC-005: Unfreeze Akun

**Actors:** Admin IT (only), Siswa (frozen subject)

**Main Flow:**
1. Admin IT opens Unfreeze page → sees all frozen accounts
2. Admin IT verifies student identity physically (in-person gawai check):
   - Verify student identity card
   - Verify bound device matches record
3. Admin IT taps "Unfreeze Akun (Verifikasi Fisik)"
4. System:
   - `FreezeState.status_freeze = false`
   - `FreezeState.waktu_unfreeze = NOW`
   - `FreezeState.count_fail = 0`
   - `User.status_akun = "Aktif"`
5. Audit log entry: "Unfreeze akun siswa_id=X oleh Admin IT (verifikasi fisik)"

**Exception Flow (No Frozen Accounts):**
- List is empty with "Tidak ada akun yang difreeze" message

**Business Rules:**
- **NO remote unfreeze** — physical verification is MANDATORY
- Unfreeze is RESTRICTED to Admin IT role only
- Guru, Siswa, Orang Tua, Kepala Sekolah CANNOT unfreeze
