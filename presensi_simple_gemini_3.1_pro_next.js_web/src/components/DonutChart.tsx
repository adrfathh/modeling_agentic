interface DonutChartProps {
  hadir: number;
  terlambat: number;
  alpa: number;
  size?: number;
}

export default function DonutChart({
  hadir,
  terlambat,
  alpa,
  size = 160,
}: DonutChartProps) {
  const total = hadir + terlambat + alpa;
  const pct = total === 0 ? 0 : Math.round(((hadir + terlambat) / total) * 100);

  const r = 60;
  const cx = size / 2;
  const cy = size / 2;
  const circumference = 2 * Math.PI * r;
  const gap = 4;

  const segments = [
    { value: hadir, color: "var(--color-hadir)" },
    { value: terlambat, color: "var(--color-terlambat)" },
    { value: alpa, color: "var(--color-alpa)" },
  ].filter((s) => s.value > 0);

  let offset = -90;

  return (
    <div className="donut-container">
      <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`}>
        {total === 0 ? (
          <circle
            cx={cx}
            cy={cy}
            r={r}
            fill="none"
            stroke="var(--border-default)"
            strokeWidth={16}
          />
        ) : (
          segments.map((seg, i) => {
            const pctSeg = seg.value / total;
            const segLen = circumference * pctSeg - gap;
            const dashArray = `${Math.max(segLen, 0)} ${circumference - Math.max(segLen, 0)}`;
            const rotation = offset;
            offset += pctSeg * 360;

            return (
              <circle
                key={i}
                cx={cx}
                cy={cy}
                r={r}
                fill="none"
                stroke={seg.color}
                strokeWidth={16}
                strokeDasharray={dashArray}
                strokeDashoffset={0}
                strokeLinecap="butt"
                transform={`rotate(${rotation} ${cx} ${cy})`}
              />
            );
          })
        )}
      </svg>
      <div className="donut-center">
        <div className="text-display" style={{ fontSize: "1.75rem" }}>
          {pct}%
        </div>
        <div className="text-micro">Kehadiran</div>
      </div>
      <div className="donut-legend">
        <div className="donut-legend-item">
          <span className="status-dot status-dot--hadir" />
          Hadir ({hadir})
        </div>
        <div className="donut-legend-item">
          <span className="status-dot status-dot--terlambat" />
          Telat ({terlambat})
        </div>
        <div className="donut-legend-item">
          <span className="status-dot status-dot--alpa" />
          Alpa ({alpa})
        </div>
      </div>
    </div>
  );
}
