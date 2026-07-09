# UC-004: Bypass Manual Ter-Audit

**Actors:** Guru (initiator), Admin IT (approver)

**Main Flow:**
1. Guru opens Bypass page → enters Siswa ID + mandatory alasan
2. System captures:
   - GPS coordinates (`koordinat_gps`)
   - Guru device UUID (`uuid_gawai_guru`)
   - Timestamp
3. System creates `AttendanceRecord` with `status: "Waiting for Approval", status_verifikasi: "Menunggu Verifikasi Admin IT"`
4. System creates `BypassLog` with `status_persetujuan: "Waiting for Approval"`
5. Record appears in Admin IT dashboard for review

**Alternative Flow (Alasan Empty):**
- Form validation prevents submission
- "Alasan bypass wajib diisi" error

**Exception Flow (Admin Rejects):**
- Admin IT rejects bypass → `BypassLog.status_persetujuan = "Rejected"`
- `AttendanceRecord.status` remains "Waiting for Approval"
- Siswa must attempt normal flow

**Alternative Flow (Admin Approves):**
- Admin IT approves → `BypassLog.status_persetujuan = "Approved"`
- `AttendanceRecord.status` updated to "Hadir"
- `AttendanceRecord.status_verifikasi` = "Terverifikasi"
