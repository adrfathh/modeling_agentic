// lib/features/admin_it/data/repositories/admin_repository.dart


class AdminDashboardData {
  final int totalSiswa;
  final int hadirToday;
  final int alpaToday;
  final int frozenCount;
  final int unboundDevices;
  const AdminDashboardData({required this.totalSiswa, required this.hadirToday, required this.alpaToday, required this.frozenCount, required this.unboundDevices});
}

class FrozenStudent {
  final String id;
  final String name;
  final String kelas;
  final int failCount;
  final DateTime freezeTimestamp;
  const FrozenStudent({required this.id, required this.name, required this.kelas, required this.failCount, required this.freezeTimestamp});
}

class BoundDevice {
  final String siswaId;
  final String siswaName;
  final String kelas;
  final String deviceId;
  final DateTime boundAt;
  final bool isActive;
  const BoundDevice({required this.siswaId, required this.siswaName, required this.kelas, required this.deviceId, required this.boundAt, required this.isActive});
}

abstract class AdminRepository {
  Future<AdminDashboardData> getDashboardData();
  Future<List<FrozenStudent>> getFrozenStudents();
  Future<void> unfreezeStudent(String id, String reason);
  Future<List<BoundDevice>> getBoundDevices();
}

class MockAdminRepository implements AdminRepository {
  @override
  Future<AdminDashboardData> getDashboardData() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const AdminDashboardData(totalSiswa: 324, hadirToday: 289, alpaToday: 12, frozenCount: 3, unboundDevices: 5);
  }

  @override
  Future<List<FrozenStudent>> getFrozenStudents() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      FrozenStudent(id: 'f1', name: 'Hendra Kurniawan', kelas: 'X IPA 1', failCount: 3, freezeTimestamp: DateTime.now().subtract(const Duration(hours: 2))),
      FrozenStudent(id: 'f2', name: 'Indah Lestari', kelas: 'XI IPS 2', failCount: 3, freezeTimestamp: DateTime.now().subtract(const Duration(hours: 5))),
      FrozenStudent(id: 'f3', name: 'Joko Mulyono', kelas: 'XII IPA 3', failCount: 3, freezeTimestamp: DateTime.now().subtract(const Duration(days: 1))),
    ];
  }

  @override
  Future<void> unfreezeStudent(String id, String reason) async => Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<List<BoundDevice>> getBoundDevices() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      BoundDevice(siswaId: 's1', siswaName: 'Ahmad Rizky', kelas: 'XI IPA 2', deviceId: 'a1b2c3d4', boundAt: DateTime.now().subtract(const Duration(days: 30)), isActive: true),
      BoundDevice(siswaId: 's2', siswaName: 'Budi Santoso', kelas: 'X IPA 1', deviceId: 'e5f6g7h8', boundAt: DateTime.now().subtract(const Duration(days: 15)), isActive: true),
    ];
  }
}
