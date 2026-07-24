"use client";

import StatusChip from "@/components/StatusChip";

const students = [
  { name: "Hendra Kurniawan", kelas: "X IPA 1", issue: "Frozen — 3x gagal biometrik", type: "freeze" as const, days: 0, status: "alpa" as const },
  { name: "Indah Lestari", kelas: "XI IPS 2", issue: "5 hari alpa berturut-turut", type: "alpa" as const, days: 5, status: "alpa" as const },
  { name: "Joko Mulyono", kelas: "XII IPA 3", issue: "Perangkat tidak terdaftar", type: "device" as const, days: 2, status: "waiting" as const },
];

export default function AlertsPage() {
  return (
    <>
      <div style={{ marginBottom: "24px" }}>
        <h1 className="text-h1">⚠️ Siswa Bermasalah</h1>
        <p className="text-body">Siswa yang memerlukan perhatian segera</p>
      </div>

      <div className="alert alert--danger">
        {students.length} siswa memerlukan tindakan dari Admin IT atau Wali Kelas
      </div>

      {students.map((s) => (
        <div key={s.name} className="card" style={{ marginBottom: "12px", display: "flex", alignItems: "center", gap: "16px" }}>
          <div className="data-table-avatar" style={{ background: s.type === "freeze" ? "var(--color-waiting)" : "var(--color-alpa)", flexShrink: 0 }}>
            {s.name[0]}
          </div>
          <div style={{ flex: 1 }}>
            <div className="text-body-bold">{s.name}</div>
            <div className="text-caption">{s.kelas}</div>
          </div>
          <div style={{ flex: 1 }}>
            <div className="text-body">{s.issue}</div>
            {s.days > 0 && <div className="text-caption" style={{ color: "var(--color-alpa)" }}>{s.days} hari berturut-turut</div>}
          </div>
          <StatusChip status={s.status} />
          <button className="btn btn--outline btn--sm">Detail</button>
        </div>
      ))}
    </>
  );
}
