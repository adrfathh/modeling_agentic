# UC-002: Barcode Scan Cycle

**Actors:** Siswa (generates), Guru (scans)

**Main Flow:**
1. Siswa taps "Generate Barcode" → system generates AES-256-CBC encrypted payload + HMAC-SHA256 signature
2. Barcode displayed with 30s countdown (auto-refresh on expiry)
3. Guru opens Scanner page → system checks Geofence (GPS ≤ 100m radius sekolah)
4. If in range → camera/scanner input enabled
5. Guru scans barcode → system decrypts + verifies HMAC + checks expiry
6. If valid → proceed to Face Liveness Detection (UC-003)
7. Jika valid + liveness passed → AttendanceRecord created with `status: "Hadir", sumber_data: "Scan Barcode+Biometrik"`
8. `terlambatmenit` calculated as `waktu_presensi - jam_mulai_jadwal`

**Alternative Flow (Barcode Expired):**
- Scanner rejects with "Barcode tidak valid atau sudah kedaluwarsa"
- Siswa must regenerate

**Exception Flow (Geofence Fail):**
- Scanner disabled, "Kamera diblokir — GPS di luar radius sekolah (≤ 100m)"
- No attendance can be processed

**Exception Flow (HMAC Mismatch):**
- "Barcode tidak valid — kemungkinan manipulasi data"
- Audit log entry created
