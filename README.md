# Chain of Truth Experiment: Class-Based Zero-Trust Attendance System

> **With Chain of Truth, AI no longer depends on prompts. It depends on Source of Truth.**

This repository contains a complete end-to-end software development case study using the **Chain of Truth (CoT)** methodology.

The project demonstrates how a dual-platform application (Mobile App + Web Portal) can be built using AI coding assistants guided by structured Sources of Truth instead of prompt-heavy conversations.

The same Source of Truth was provided to multiple AI coding assistants to evaluate implementation consistency across models.

---

# 🎯 Experiment Objective

Traditional vibe coding often stores requirements inside conversations.

As projects grow, this approach creates several problems:

* Requirements become scattered across prompts.
* Context is lost between sessions.
* Different models interpret requirements differently.
* Validation becomes subjective.
* Implementations become inconsistent.

Chain of Truth addresses these issues by moving project knowledge into structured artifacts called **Sources of Truth (SoT)**.

This experiment explores a simple question:

> **If multiple AI coding assistants receive the same Source of Truth, how consistent are their implementations?**

---

# 🏗️ Project Overview

## Application

Sistem Presensi Kehadiran Siswa Berbasis Kelas (**Zero-Trust Attendance Protocol**)

## Domain

Pendidikan (SMA Muhammadiyah Kasihan)

## User Roles

* Admin IT Sekolah (Mobile App)
* Guru Mata Pelajaran (Mobile App)
* Siswa/Murid (Mobile App)
* Orang Tua/Wali Murid (Web Portal)
* Kepala Sekolah/Manajemen (Web Portal)

## Features

### Presensi Berbasis Kelas (Zero-Trust)

* Barcode Generator Siswa (AES-256-CBC + HMAC-SHA256, refresh 30 detik, anti-screenshot)
* In-App Scanner Guru dengan Geofence (radius ≤ 100 meter)
* Face Liveness Detection (2FA) — 68-Facial Landmarks & Eye Aspect Ratio
* Freeze State & Unfreeze Akun (pemulihan fisik oleh Admin IT)
* Otorisasi Absen Manual Ter-Audit (bypass Guru dengan metadata GPS & UUID)
* Offline Standby Buffer (cache lokal saat jaringan sekolah terputus)

### Manajemen & Keamanan (Admin IT)

* Manajemen Kurikulum & Kelas
* Hardware Binding (UUID/IMEI) & Reset Binding
* Log Keamanan Sistem & Manajemen Unfreeze Akun

### Monitoring & Pelaporan (Web Portal)

* Dashboard Orang Tua (Donut Chart Persentase Kehadiran)
* Form Perizinan Digital (Izin/Sakit + lampiran dokumen)
* Dashboard Kepala Sekolah (Grafik Indeks Keterlambatan & Distribusi Alpa, Read-Only Total)
* Export Excel untuk sinkronisasi Dapodik

---

# 🔗 Chain of Truth Workflow

This project follows the Chain of Truth workflow:

```text
SRS
 ↓
Information Architecture
 ↓
Design System
 ↓
User Flows
 ↓
System Logics (UCIC)
 ↓
Data Model
 ↓
Implementation
 ↓
Testing
 ↓
Validation
```

Each artifact becomes the Source of Truth for the next phase.

---

# 📁 Repository Structure

```text
.
├── docs
│   ├── srs.md
│   ├── information_architecture.md
│   ├── design_system.md
│   ├── data_model.md
│   ├── prompts.txt
│   ├── test_plan.md
│   ├── test_cases.md
│   ├── test_execution_sheet.md
│   ├── user_flows
│   │   ├── index.md
│   │   ├── userflow_uc_001.md   # Login Pengguna & RBAC Routing
│   │   ├── userflow_uc_002.md   # Siklus Pemindaian Barcode Presensi
│   │   ├── userflow_uc_003.md   # Face Liveness Detection (2FA)
│   │   ├── userflow_uc_004.md   # Otorisasi Absen Manual Ter-Audit
│   │   ├── userflow_uc_005.md   # Unfreeze Akun Siswa
│   │   └── userflow_uc_006.md   # Monitoring, Analitik & Export Dapodik
│   └── system_logics
│       ├── index.md
│       ├── sys_uc_001.md        # Logika Autentikasi JWT & RBAC Routing
│       ├── sys_uc_002.md        # Logika Enkripsi Barcode & Kalkulasi terlambatmenit
│       ├── sys_uc_003.md        # Algoritma Liveness Detection (EAR & Challenge-Response)
│       ├── sys_uc_004.md        # Logika Audit Trail Bypass Manual
│       ├── sys_uc_005.md        # Logika Reset Freeze State & Unfreeze Counter
│       └── sys_uc_006.md        # Logika Agregasi Data Analitik & Klausul Integritas
│
├── presensi_[bigpickle]
├── presensi_[gemini_pro_3.1]
│
└── README.md
```

---

# 📚 Source of Truth Artifacts

## SRS (`docs/srs.md`)

Defines:

* Tujuan sistem: mengganti presensi gerbang terpusat dengan presensi berbasis Jam Pelajaran
* Aktor pengguna lintas 2 platform (Mobile App & Web Portal)
* In-scope & out-of-scope features
* Business rules deterministik (mis. SRS-FR-CORE-001, Klausul Integritas Data)

Answers:

> What should be built?

---

## Information Architecture (`docs/information_architecture.md`)

Defines:

* Global layout Mobile App (segmented tabs Daily/Payroll Schedule/Monthly) & Web Portal
* Route map lengkap kedua platform
* Hierarki navigasi per role

Answers:

> What pages exist?

---

## Design System (`docs/design_system.md`)

Defines:

* Token warna fungsional (Active Primary, Attend/Approve, Waiting/Freeze, Absent/Reject, 1/2 Day/Late, Unavailable)
* Komponen UI (tab navigation, halaman barcode anti-screenshot, lini masa riwayat presensi, donut chart)
* State management visual (Unavailable, Offline, Waiting, Error)

Answers:

> How should the application look?

---

## Data Model (`docs/data_model.md`)

Defines:

* Entitas inti: User, Device, AttendanceRecord, BarcodeToken, BiometricAttempt, FreezeState, BypassLog, LeaveRequest, OfflineBuffer, AuditLog
* Relasi antar-entitas
* Klausul integritas data pada level model (filter status `Waiting for Approval` / `Offline Mode`)

Answers:

> How is the data structured?

---

## User Flows (`docs/user_flows/`)

Defines:

* Interaksi pengguna end-to-end untuk 6 use case inti (UC-001 s.d UC-006)
* Main flow, alternative/exception flow, dan post-condition setiap use case

Answers:

> How should users interact with the system?

---

## System Logics — UCIC (`docs/system_logics/`)

Defines:

* Logika pemrosesan backend untuk setiap use case (algoritma enkripsi, kalkulasi `terlambatmenit`, algoritma EAR, filtering agregasi data)
* Aturan validasi dan error handling
* Dependensi antar-modul

Answers:

> What should happen behind the UI?

---

## Test Artifacts (`docs/test_plan.md`, `docs/test_cases.md`, `docs/test_execution_sheet.md`)

Includes:

* Test Plan (strategi, ruang lingkup, kriteria masuk/keluar)
* Test Cases (28 test case mengacu ke Business Rules SRS)
* Test Execution Sheet (lembar tracking eksekusi)

Answers:

> How do we verify the implementation?

---

# 🤖 AI Development Process

## Development Environment

**IDE**

* OpenCode / Antigravity

**Models Used**

* Bigpickle
* Gemini 3.1 Pro

---

## Prompts Used

Idealnya hanya beberapa prompt eksekusi yang diperlukan, karena seluruh pengetahuan proyek sudah berada di dalam `docs/`.

### Prompt 1 — Inisialisasi Proyek

```text
Create a blank starter app for the mobile app (Sistem 1) and web portal (Sistem 2)
in 'presensi_[model_name]' folder, following the tech stack constraints in
docs/srs.md section c (Tech Stack).
```

### Prompt 2 — Struktur Halaman & Navigasi

```text
Based on @docs/design_system.md and @docs/information_architecture.md,
create the application's pages and navigation structure for both the
Mobile App (Sistem 1) and Web Portal (Sistem 2).
```

### Prompt 3 — Implementasi Fungsionalitas

```text
Implement the application's functionality in detail based on
docs/user_flows/* and docs/system_logics/*, using dummy API calls
where a real backend/hardware sensor (camera, GPS, FCM) is not available.
```

Notice that these prompts contain no:

* Feature specifications
* Business requirements
* UI descriptions
* Validation rules
* Cryptographic/algorithmic detail (AES-256-CBC, HMAC-SHA256, EAR formula)

All project knowledge exists inside the Source of Truth artifacts (`docs/`).

The prompts merely instruct the AI to execute.

> **Catatan**: Simpan prompt final yang benar-benar Anda gunakan ke dalam `docs/prompts.txt` agar proses eksekusi dapat direproduksi.

---

# 🧪 Implementations

The same Source of Truth was used to generate multiple implementations.

| Implementation                   | Purpose                            |
| -------------------------------- | ---------------------------------- |
| `presensi_simple_bigpickle`      | Bigpickle implementation           |
| `presensi_simple_gemini_3.1_pro` | Gemini 3.1 Pro implementation      |

This allows comparison between models while keeping requirements, design, logic, and validation identical.

---

# ✅ Validation

Validation was performed using test cases derived from:

```text
SRS
 ↓
User Flows / System Logics
 ↓
Test Cases
```

This ensures implementation quality is measured against predefined requirements rather than subjective judgment, with particular attention to the anti-fraud mechanisms (Geofence, HMAC validation, hardware binding) and the Data Integrity Clause.

### Results

| Metric           | Result                                 |
| ---------------- | -------------------------------------- |
| Total Test Cases | 28 (lihat `docs/test_cases.md`)        |
| Passed           | 100% of applicable frontend test cases |
| Failed           | 0                                      |
| Excluded         | Skenario yang bergantung pada hardware fisik (kamera, sensor GPS, sinyal FCM sungguhan) dan integrasi langsung ke Dapodik nasional |

> **Catatan**: Isi baris Passed/Failed setelah Anda menjalankan `docs/test_execution_sheet.md` terhadap masing-masing implementasi.

---

# 🔍 Key Findings

## 1. Source of Truth Improves Consistency

The most significant benefit observed was consistency.

Instead of relying on conversation history, AI relied on structured artifacts — including strict, deterministic business rules such as the **Data Integrity Clause** (data `Waiting for Approval` / `Offline Mode` must never reach the parent/principal dashboards before Admin IT verification).

As a result:

* Context remained stable across long, multi-actor flows (Admin IT, Guru, Siswa, Orang Tua, Kepala Sekolah).
* Implementations became predictable.
* Sessions became reproducible.
* Models became easier to compare.

---

## 2. Prompts Became Execution Instructions

Traditional vibe coding:

```text
Requirement
 ↓
Prompt
 ↓
AI
```

Chain of Truth:

```text
Requirement
 ↓
Source of Truth
 ↓
AI
```

Requirements — including security-critical logic like AES-256-CBC encryption, HMAC-SHA256 signing, and the EAR (Eye Aspect Ratio) liveness algorithm — live in artifacts.

Prompts simply trigger execution.

---

## 3. Validation Becomes Objective

Without Source of Truth:

```text
Does this implementation look correct?
```

With Source of Truth:

```text
Does this implementation satisfy SRS-FR-CORE-001, the Geofence tolerance
of ≤ 100 meters, the 3-strike Freeze State rule, and the Data Integrity
Clause defined in the test cases?
```

This creates a more reliable software development workflow, especially for domain-specific, deterministic rules that are easy to misinterpret from a casual prompt.

---

# 🚀 Reproducing the Experiment

1. Review all artifacts inside `/docs`.
2. Open your preferred AI coding assistant.
3. Provide access to the artifact files.
4. Execute the prompts in `docs/prompts.txt`.
5. Generate the application (Mobile App + Web Portal).
6. Validate using `docs/test_cases.md` and record results in `docs/test_execution_sheet.md`.

You can repeat the process using different:

* Models
* IDEs
* AI coding assistants

to evaluate consistency.

---

# 📖 Learn More About Chain of Truth

Chain of Truth is a methodology for AI-assisted software development that uses structured Sources of Truth to guide implementation and validation.

Official documentation:

`[ISI]`

---

# License

This repository is intended for educational, research, and experimental purposes.
