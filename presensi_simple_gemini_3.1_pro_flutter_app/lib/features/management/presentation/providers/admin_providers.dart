// lib/features/admin_it/presentation/providers/admin_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_app/features/management/data/repositories/admin_repository.dart';

final adminRepoProvider = Provider<AdminRepository>((_) => MockAdminRepository());
final adminDashProvider = FutureProvider<AdminDashboardData>((ref) => ref.read(adminRepoProvider).getDashboardData());
final frozenStudentsProvider = FutureProvider<List<FrozenStudent>>((ref) => ref.read(adminRepoProvider).getFrozenStudents());
final boundDevicesProvider = FutureProvider<List<BoundDevice>>((ref) => ref.read(adminRepoProvider).getBoundDevices());
