interface KpiCardProps {
  value: string | number;
  label: string;
  variant: "hadir" | "alpa" | "waiting" | "primary" | "terlambat";
  delta?: { value: string; direction: "up" | "down" };
}

export default function KpiCard({ value, label, variant, delta }: KpiCardProps) {
  return (
    <div className={`kpi-card kpi-card--${variant}`}>
      <div className="kpi-value" style={{ color: `var(--color-${variant})` }}>
        {value}
      </div>
      <div className="kpi-label">{label}</div>
      {delta && (
        <div className={`kpi-delta kpi-delta--${delta.direction}`}>
          {delta.direction === "up" ? "↑" : "↓"} {delta.value}
        </div>
      )}
    </div>
  );
}
