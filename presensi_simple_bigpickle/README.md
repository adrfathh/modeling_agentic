# Sistem Presensi Kehadiran Siswa Berbasis Kelas (Zero-Trust Attendance Protocol)

**SMA Muhammadiyah Kasihan** — Frontend Prototype (Phase 3)

A runnable frontend prototype demonstrating the ZTA attendance system with 5 roles, dynamic barcode, face liveness verification, geofence-gated scanning, audit-trailed manual bypass, freeze/unfreeze flows, and role-based dashboards — all client-side with in-memory mock data.

## Tech Stack

- **Flutter** — cross-platform framework for building native-like apps from a single codebase
- **Dart** — object-oriented, strongly typed language optimized for UI
- **Shared Preferences / Secure Storage** — for JWT token persistence (no real backend)

## Install & Run

```bash
flutter pub get
flutter run
```

Run on your preferred device (Android/iOS emulator, or Chrome for web testing).

## Demo Credentials

| Role | Username | Password | Redirect |
|------|----------|----------|----------|
| Admin IT | `admin` | `admin123` | `/dashboard-admin` |
| Guru | `guru` | `guru123` | `/dashboard-guru` |
| Siswa | `siswa1` | `siswa123` | `/dashboard-siswa` |
| Orang Tua | `ortu` | `ortu123` | `/dashboard-orangtua` |
| Kepala Sekolah | `kepsek` | `kepsek123` | `/dashboard-kepsek` |

## Testing the Core Flows

### UC-001: Login & RBAC Routing
1. Log in as each role above
2. Verify redirect matches the table
3. Verify role-specific navigation menus appear
4. Cross-role access blocked (e.g., log in as siswa, manually navigate to `/dashboard-admin` → redirected to `/login`)

### UC-002: Barcode Scan Cycle
1. Log in as **siswa1** → tap **Barcode** → observe 30s circular countdown ring, auto-refresh
2. Log in as **guru** → tap **Scanner** → geofence check runs (mock GPS in range)
3. Type `abcd1234:efgh5678` in scanner input → tap **Simulasikan Scan** → see "Barcode valid!"
4. Wire data: scanner output feeds into biometric step

### UC-003: Face Liveness Detection + Freeze
1. Log in as **siswa1** → tap **Biometric**
2. Tap **Deteksi Wajah** (EAR simulated) → if EAR > 0.2, tap **Submit Presensi** → "Hadir" recorded
3. To test freeze: modify `crypto_utils.dart` `isLivenessPassed` to return `false`; submit 3x → account frozen
4. Frozen user sees "Akun Difreeze" overlay and cannot proceed

### UC-004: Bypass Manual Ter-Audit
1. Log in as **guru** → tap **Bypass**
2. Enter Siswa ID `5` + alasan → tap **Ajukan Bypass**
3. Log in as **admin** → Dashboard shows pending bypass with GPS/UUID audit trail
4. Tap **Setujui** → bypass approved, attendance updated to "Hadir"

### UC-005: Unfreeze Akun
1. Log in as **admin** → tap **Unfreeze**
2. Tap **Unfreeze Akun** on a frozen student → **checklist confirmation** appears
3. Check "Saya telah memverifikasi identitas siswa secara fisik" → tap **Konfirmasi Unfreeze**
4. Audit log: "Unfreeze siswa ID X oleh Admin IT (verifikasi fisik)"

### UC-006: Monitoring / Analytics / Export
1. Log in as **ortu** → Donut chart shows bold center % + "Today's Attendance Percentage"
2. Tap **Monitoring** → vertical timeline with per-status colored dots
3. Log in as **kepsek** → summary cards, latency bar chart, alpa distribution
4. Tap **Export** → select period → "Download Excel" (simulated)
5. **Data Integrity Clause**: "Waiting for Approval" records excluded from all above views

## Data Integrity Clause

Records with `status === "Waiting for Approval"` or `status_verifikasi === "Menunggu Verifikasi Admin IT"` are **strictly excluded** from all Orang Tua and Kepala Sekolah dashboard queries. These records only appear in the Admin IT dashboard until approved.

## Reset App State

```bash
# To clear SharedPreferences (mock DB state), you can uninstall and reinstall the app on the emulator,
# or clear app data from the device settings.
# For web testing: clear localStorage in browser dev tools.
```

## Project Structure

```text
lib/
├── core/
│   ├── theme/          # Design tokens and theme configs
│   ├── utils/          # crypto_utils.dart (AES/HMAC/EAR sim)
│   └── api/            # In-memory mock API (30+ endpoints)
├── models/             # Data models and entities
├── providers/          # State management and Auth (JWT/RBAC)
├── screens/
│   ├── mobile/         # Admin IT, Guru, Siswa screens
│   ├── web/            # Orang Tua, Kepala Sekolah screens
│   └── login/          # Login screen (all roles)
├── widgets/            # Reusable UI (SegmentedTabs, DateNavigator, dll)
└── main.dart           # App entry point & router
docs/
├── srs.md              # Source of Truth #1 (functional requirements)
├── information_architecture.md # Source of Truth #2 (route map)
├── design_system.md    # Source of Truth #3 (color tokens, components)
├── data_model.md       # Source of Truth #4 (entities, relations)
├── user_flows/         # UC-001 to UC-006 end-to-end flows
├── system_logics/      # SYS-UC-001 to SYS-UC-006 backend rules
└── prompts.txt         # Reproducible prompt chain
```

## Chain of Truth Workflow

Per `docs/prompts.txt`, all implementation decisions are traceable to numbered requirements in `docs/srs.md` and enforced by the corresponding `docs/system_logics/*.md` rules. See `IMPLEMENTATION_NOTES.md` for deviations and assumptions.
