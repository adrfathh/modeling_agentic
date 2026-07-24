// lib/core/network/offline_cache.dart
//
// Encrypted Offline Cache — Hive-based
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════
// Stores attendance scan data encrypted when offline.

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Encrypted local cache for offline attendance data.
///
/// Uses Hive with AES encryption for at-rest data protection.
/// Cached entries are synced to server when connectivity is restored.
class OfflineCache {
  static const String _boxName = 'offline_attendance_cache';
  static const String _pendingKey = 'pending_entries';

  Box? _box;

  /// Initialize the encrypted cache box.
  Future<void> init() async {
    await Hive.initFlutter();
    
    const secureStorage = FlutterSecureStorage();
    String? encodedKey = await secureStorage.read(key: 'hive_offline_cache_key');
    if (encodedKey == null) {
      final key = Hive.generateSecureKey();
      encodedKey = base64UrlEncode(key);
      await secureStorage.write(key: 'hive_offline_cache_key', value: encodedKey);
    }
    final key = base64Url.decode(encodedKey);
    
    _box = await Hive.openBox(_boxName, encryptionCipher: HiveAesCipher(key));
  }

  /// Save an attendance entry to offline cache.
  Future<void> cacheEntry(Map<String, dynamic> entry) async {
    final entries = getPendingEntries();
    entries.add(entry);
    await _box?.put(_pendingKey, json.encode(entries));
  }

  /// Get all pending (unsynced) entries.
  List<Map<String, dynamic>> getPendingEntries() {
    final raw = _box?.get(_pendingKey) as String?;
    if (raw == null) return [];
    final decoded = json.decode(raw) as List;
    return decoded.cast<Map<String, dynamic>>();
  }

  /// Get the count of pending entries.
  int get pendingCount => getPendingEntries().length;

  /// Remove synced entries after successful upload.
  Future<void> clearSyncedEntries(List<String> syncedIds) async {
    final entries = getPendingEntries();
    entries.removeWhere(
      (e) => syncedIds.contains(e['localId'] as String?),
    );
    await _box?.put(_pendingKey, json.encode(entries));
  }

  /// Clear all cached data.
  Future<void> clearAll() async {
    await _box?.clear();
  }
}
