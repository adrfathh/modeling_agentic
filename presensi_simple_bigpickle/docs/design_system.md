# Design System — Sistem Presensi Kehadiran Siswa

## 1. Mandatory Functional Color Tokens

| Token Name          | Hex       | Functional Purpose                                  | CSS Variable          |
|---------------------|-----------|------------------------------------------------------|-----------------------|
| Active Primary      | `#3182CE` | All interactive elements, links, primary buttons      | `--color-primary`     |
| Attend / Approve    | `#48BB78` | Hadir, approved, success states, green indicators     | `--color-attend`      |
| Waiting / Freeze    | `#805AD5` | Pending verification, frozen account, waiting states  | `--color-waiting`     |
| Absent / Reject     | `#E53E3E` | Alpa, rejected, error states, danger indicators       | `--color-absent`      |
| 1/2 Day / Late      | `#ECC94B` | Terlambat, half-day, warning states                   | `--color-late`        |
| Unavailable/Offline | `#A0AEC0` | Offline mode, unavailable data, disabled elements     | `--color-offline`     |

### Color Usage Rules
- **Data Integrity Clause**: `Waiting/Freeze (#805AD5)` and `Unavailable/Offline (#A0AEC0)` MUST never visually blend into or be used interchangeably with `Attend/Approve (#48BB78)` or `Absent/Reject (#E53E3E)`. These colors are reserved exclusively for non-final, transitional, or unavailable states.
- Background tints use 10% opacity of the functional color (e.g., `#805AD5` at 10% opacity for waiting card backgrounds).

## 2. Visual States

| State                | Token Used     | Description                                         |
|----------------------|----------------|------------------------------------------------------|
| Active               | `#3182CE`      | Normal functioning state                             |
| Attend / Present     | `#48BB78`      | Verified attendance                                   |
| Late                 | `#ECC94B`      | Terlambat, arrived after start time                   |
| Absent / Reject      | `#E53E3E`      | Alpa or rejected bypass                               |
| Waiting              | `#805AD5`      | Pending verification, unfreeze needed                 |
| Offline / Unavailable| `#A0AEC0`      | Device offline, data unavailable                      |
| Error / Blokir       | `#E53E3E`      | Camera blocked, geofence violation, freeze active     |

## 3. Mandatory UI Components

### 3.1 Segmented Tab Navigation
- Three segments: **Daily** | **Payroll Schedule** | **Monthly**
- Active tab indicated by a bottom underline (2px solid in `#3182CE`)
- Inactive tabs: gray text with no underline
- Tabs are horizontally scrollable on mobile
- Date navigator sits directly below the segmented tabs (previous/next arrow + date range label)

### 3.2 Anti-Screenshot Barcode Page
- **FLAG_SECURE** indicator banner (yellow/warning style)
- Dynamic QR visual with 30-second auto-countdown
- Countdown displayed as a **circular ring progress bar** (SVG circle stroke-dasharray)
- Barcode token auto-refreshes on expiry
- Manual refresh button available

### 3.3 Guru Scanner — Camera Gated by Geofence
- Geofence status indicator card at top
- PASS (`#48BB78`) — camera available, scanner input enabled
- FAIL (`#E53E3E`) — "Kamera diblokir" overlay with error icon and GPS distance explanation
- Scanner input only rendered when geofence passes

### 3.4 Vertical Attendance History Timeline
- Each record is a horizontal row with:
  - **Status dot** (colored circle per status)
  - Date/time text
  - Status badge
- Dots: `#48BB78` for Hadir, `#ECC94B` for Terlambat, `#3182CE` for Sakit, `#E53E3E` for Alfa
- Connecting vertical line between dots (on desktop timeline view)

### 3.5 Donut Chart (Orang Tua Dashboard)
- SVG-based donut ring
- **Bold large center percentage** (e.g., "75%")
- **Thin subtitle** below: "Today's Attendance Percentage"
- Legend row beneath showing color blocks + label + count

### 3.6 Indeks Keterlambatan Bar Chart (Kepala Sekolah)
- Horizontal stacked bar per subject (mapel)
- Green = Hadir, Yellow = Terlambat, Red = Alpa segments
- Latency percentage annotation on each bar

### 3.7 Alpa Distribution Chart (Kepala Sekolah)
- Vertical bar chart: one bar per status (Hadir, Terlambat, Sakit, Alfa)
- Each bar is colored per its status token
- Count label above each bar

## 4. UI Kit (Defaults where not otherwise specified)

### Typography
- Font: system sans-serif stack (`-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif`)
- Sizes: `[10px, 12px, 14px, 16px, 18px, 24px]` mapped to `[caption, small, body, h4, h3, h2]`
- Font weights: `400` (regular), `600` (semibold), `700` (bold)

### Buttons
- Primary: `bg-[#3182CE] text-white` with 8px border-radius
- Success: `bg-[#48BB78] text-white`
- Danger: `bg-[#E53E3E] text-white`
- Outline: `border border-border text-text-muted` with transparent bg
- Sizes: compact (`px-3 py-1.5 text-xs`), default (`px-4 py-2 text-sm`), large (`px-6 py-3 text-sm`)

### Cards
- Background: white (`#FFFFFF`)
- Border: `1px solid #E2E8F0`
- Border-radius: `12px`
- Padding: `16px` (default), `24px` (large)
- Shadow: `0 1px 3px rgba(0,0,0,0.05)` (optional, not mandatory)

### Inputs
- Border: `1px solid #E2E8F0`
- Border-radius: `8px`
- Focus state: `border-[#3182CE]` with `outline: none`
- Padding: `8px 12px`
- Font size: `14px`

### Data Table (Export preview, monitoring)
- Header row: `bg-gray-50` with bold `12px` text
- Body rows: alternating white, no hover effect
- Border: horizontal `1px solid #E2E8F0` dividers only
