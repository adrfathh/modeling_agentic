interface StatusChipProps {
  status: "hadir" | "alpa" | "waiting" | "terlambat";
  label?: string;
}

const defaultLabels: Record<string, string> = {
  hadir: "Hadir",
  alpa: "Alpa",
  waiting: "Menunggu",
  terlambat: "Terlambat",
};

export default function StatusChip({ status, label }: StatusChipProps) {
  return (
    <span className={`status-chip status-chip--${status}`}>
      <span className={`status-dot status-dot--${status}`} />
      {label || defaultLabels[status]}
    </span>
  );
}
