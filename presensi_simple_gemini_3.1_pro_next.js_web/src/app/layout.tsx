import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Presensi SMA Muhammadiyah Kasihan — Web Portal",
  description:
    "Zero-Trust Attendance Protocol — Portal untuk Orang Tua dan Kepala Sekolah",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="id">
      <body>{children}</body>
    </html>
  );
}
