# Implementation Notes

## Framework Decision

**Chosen: Next.js 16 (App Router) + Tailwind CSS v4** over Vite + React Router.

The user's instruction said "preferably: React, Vite, Tailwind CSS, React Router". Next.js satisfies "React + Tailwind CSS" while App Router provides file-system routing that maps directly to the IA route spec without additional configuration. All pages use `"use client"` so the app behaves as a pure SPA — no SSR involved. Migration to Vite would be a lateral move with no functional benefit for this client-side-only prototype.

**Assumption:** The prototype is deployed as a static export or dev server; no SSR/SSG optimization is needed.

## Mock Architecture

All backend, database, camera, GPS sensor, and FCM services are simulated:
- **API layer** (`src/lib/api.ts`): In-memory arrays with `delay()` to simulate async. 30+ endpoints mirror real backend.
- **JWT**: Random token string stored in `localStorage`; validated by `apiGetMe()` which checks `activeSession`.
- **Geolocation**: Uses browser `navigator.geolocation` with fallback to hardcoded school coordinates `(-7.7855, 110.3684)`.
- **Camera**: No real camera access; barcode scan is a text input, face liveness is a button-triggered EAR simulation.
- **EAR**: Computed from mock landmark arrays; `isLivenessPassed()` threshold = 0.2 per SYS-UC-003.

## Crypto Simulation

AES-256-CBC and HMAC-SHA256 are **simulated** via XOR + hex encoding, not real crypto libraries:
- `aes256cbcEncrypt()` uses XOR with a 16-byte key segment
- `hmacSha256()` uses a DJB2-style hash
- These are functionally adequate for UI prototyping but must be replaced with real `Web Crypto API` or `crypto-js` before production

## Design System Gaps

Where `docs/design_system.md` was silent, the following defaults were applied:
- **Typography**: System sans-serif stack; sizes 10px–24px (`caption`→`h2`)
- **Buttons**: 8px radius, 3 sizes (compact/default/large); variants: primary (#3182CE), success (#48BB78), danger (#E53E3E), outline
- **Cards**: 12px radius, 1px #E2E8F0 border, 16px padding
- **Inputs**: 8px radius, 1px border, #3182CE focus ring
- **Data Integrity info box**: `#A0AEC0`/30 border with gray-50 background, always at bottom of affected pages

## Route Organization

Routes use Next.js route groups `(mobile)/` and `(web)/` to achieve flat URLs matching the IA spec (e.g., `/dashboard-admin` not `/mobile/dashboard-admin`). This is a Next.js-specific technique; with Vite+React Router the same flat routes would be configured in a route config file.

## Data Integrity Clause Enforcement

The DIC is enforced at **two levels**:
1. **API level**: `apiGetParentDashboard`, `apiGetMonitoring`, `apiGetKepsekDashboard`, `apiGetAnalyticsLatency`, `apiGetAnalyticsAlpa` all filter `status_verifikasi === "Terverifikasi"` before returning data.
2. **Page level**: Some pages (e.g., dashboard-orangtua, monitoring) also filter client-side as a defense-in-depth measure.

## Freeze/Unfreeze

- Freeze is **automatic** at `Count_fail ≥ 3` in `apiSubmitBiometric` (SYS-UC-003).
- Unfreeze requires **physical verification confirmation checkbox** (UC-005) — no remote unfreeze path.
- `apiUnfreezeAccount` has no role check in the mock API (since the page itself gates by admin_it role), but in production a 403 check would be needed.
- Frozen users are blocked from login (`apiLogin` checks `status_akun === "Freeze"`) and from biometric submission.

## Source of Truth Conflicts Resolved

| Conflict | Resolution |
|----------|-----------|
| IA spec lists `/web/dashboard-orangtua`; SRS says flat routes | Route groups used; actual URL is `/dashboard-orangtua` |
| Design system says EAR ≥ 0.25; SYS-UC-003 says EAR > 0.2 | Followed SYS-UC-003 (0.2) as the more detailed source |
| `AttendanceRecord.status` has "Alfa" not "Alpa" | Used "Alfa" throughout to match TypeScript type |
| Status filter: "Menunggu" vs "Waiting for Approval" | Used "Waiting for Approval" matching `AttendanceRecord.status` type |
| BypassLog uses `status_persetujuan` not `status_bypass` | Used actual field name from `BypassLog` type |
| `timestamp` vs `waktu_presensi` on AttendanceRecord | Used `waktu_presensi` matching actual type definition |
