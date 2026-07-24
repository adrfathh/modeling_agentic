// lib/core/auth/role_model.dart
//
// Role-Based Access Control Model
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════

/// User roles in the Zero-Trust Attendance system.
///
/// Each role maps to a distinct set of allowed routes
/// and feature capabilities. Cross-role access triggers
/// session termination [SRS-ARCH-002].
enum UserRole {
  /// Admin IT — full system access, freeze management, hardware binding
  adminIT('admin_it'),

  /// Guru Mapel — class attendance, scanning, approval, manual override
  guru('guru'),

  /// Siswa — barcode display, biometric verify (read-only own data)
  siswa('siswa');

  const UserRole(this.claimValue);

  /// The JWT claim value string for this role.
  final String claimValue;

  /// Parse role from JWT claim string.
  /// Returns null if claim value doesn't match any role.
  static UserRole? fromClaim(String? claim) {
    if (claim == null) return null;
    return UserRole.values.where((r) => r.claimValue == claim).firstOrNull;
  }
}
