# SYS-UC-004: Audit-Trailed Manual Bypass

## Bypass Creation
1. Guru submits bypass with:
   - `siswa_id` (mandatory)
   - `deskripsi_alasan` (mandatory, validated non-empty)
   - `koordinat_gps` (auto-captured from browser geolocation)
   - `uuid_gawai_guru` (device identifier from session/device binding)
   - `jadwal_id` (current teaching schedule)
   - `status_dispensasi` (default: "Hadir")
2. System creates `AttendanceRecord`:
   - `status = "Waiting for Approval"`
   - `status_verifikasi = "Menunggu Verifikasi Admin IT"`
   - `sumber_data = "Bypass Manual Guru"`
3. System creates `BypassLog`:
   - `status_persetujuan = "Waiting for Approval"`

## Bypass Approval (Admin IT)
1. Admin IT reviews bypass log
2. Taps "Setujui" → `status_persetujuan = "Approved"` + attendance updated to "Hadir"
3. Taps "Tolak" → `status_persetujuan = "Rejected"` (attendance unchanged)

## Data Integrity Clause
- Bypass records with `status_persetujuan = "Waiting for Approval"` are excluded from parent/kepsek dashboards
- Only "Approved" or "Rejected" bypasses appear in aggregate views
