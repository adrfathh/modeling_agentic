# SYS-UC-002: Barcode Generation / Geofence / Terlambatmenit Calculation

## AES-256-CBC Payload Generation
- Input: `device_id`, `koordinat_gps`, `timestamp`
- Encrypted with AES-256-CBC using fixed key+IV (mock)
- Output: `encrypted` (base64 string)

## HMAC-SHA256 Signature
- Input: `encrypted` + server secret
- Algorithm: HMAC-SHA256
- Output: `hmac` (hex string)
- Verification: regenerate HMAC from `encrypted` and compare

## Geofence Validation (≤100m)
- Sekolah coordinates: `-7.7855, 110.3684`
- Haversine formula to calculate distance from current GPS
- If `distance > 100m` → BLOCK all scanner functionality
- If `distance ≤ 100m` → ALLOW scanner

## Terlambatmenit Calculation
- On attendance submission:
  - Look up `JadwalPelajaran.jam_mulai` by `jadwal_id`
  - Parse `waktu_presensi` and `jam_mulai`
  - `terlambatmenit = max(0, (waktu_presensi - jam_mulai) in minutes)`
  - If `terlambatmenit > 0` → set `status = "Terlambat"`
