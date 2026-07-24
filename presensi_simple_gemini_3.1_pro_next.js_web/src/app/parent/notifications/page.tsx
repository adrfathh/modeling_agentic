"use client";

const notifications = [
  { id: 1, type: "info", time: "08.35 WIB", message: "Jam ke-3 (Matematika) — Barcode telah dipindai, menunggu verifikasi guru", date: "Hari ini" },
  { id: 2, type: "success", time: "08.05 WIB", message: "Jam ke-2 (Fisika) — Ahmad Rizky tercatat hadir otomatis", date: "Hari ini" },
  { id: 3, type: "success", time: "07.12 WIB", message: "Jam ke-1 (B. Indonesia) — Ahmad Rizky tercatat hadir otomatis", date: "Hari ini" },
  { id: 4, type: "warning", time: "07.25 WIB", message: "Ahmad Rizky tercatat TERLAMBAT 10 menit pada Jam ke-1 (PKN)", date: "20 Jun 2025" },
  { id: 5, type: "danger", time: "13.00 WIB", message: "Ahmad Rizky tercatat ALPA pada Jam ke-3 (Matematika). Hubungi wali kelas jika ada kendala.", date: "19 Jun 2025" },
  { id: 6, type: "success", time: "07.00 WIB", message: "Kehadiran hari ini 100% — Semua jam pelajaran tercatat hadir", date: "18 Jun 2025" },
];

export default function NotificationsPage() {
  return (
    <>
      <div style={{ marginBottom: "24px" }}>
        <h1 className="text-h1">Notifikasi</h1>
        <p className="text-body">Riwayat notifikasi kehadiran Ahmad Rizky</p>
      </div>

      {/* Group by date */}
      {["Hari ini", "20 Jun 2025", "19 Jun 2025", "18 Jun 2025"].map((date) => {
        const items = notifications.filter((n) => n.date === date);
        if (items.length === 0) return null;
        return (
          <div key={date} style={{ marginBottom: "24px" }}>
            <h4 className="text-body-bold" style={{ marginBottom: "12px" }}>{date}</h4>
            <div style={{ display: "flex", flexDirection: "column", gap: "8px" }}>
              {items.map((n) => (
                <div key={n.id} className={`alert alert--${n.type}`}>
                  <span className="text-caption" style={{ minWidth: "70px" }}>{n.time}</span>
                  {n.message}
                </div>
              ))}
            </div>
          </div>
        );
      })}
    </>
  );
}
