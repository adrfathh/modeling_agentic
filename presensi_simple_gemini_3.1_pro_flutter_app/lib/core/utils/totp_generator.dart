// lib/core/utils/totp_generator.dart
//
// TOTP Barcode Generator — AES-256-CBC + HMAC-SHA256
// Zero-Trust Attendance Protocol [SRS §2.1]
// ═══════════════════════════════════════════════════
// Generates encrypted barcode payloads that refresh every 30 seconds.

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

/// Generates time-based encrypted barcode payloads.
///
/// Payload format: `base64EncryptedData.hmacSignature.ivBase64`
///
/// Refresh cycle: 30 seconds
/// Encryption: AES-256-CBC
/// Signature: HMAC-SHA256
class TotpBarcodeGenerator {
  TotpBarcodeGenerator._();

  static const String _aesKeyBase64 = String.fromEnvironment(
    'AES_KEY',
    defaultValue: 'MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTI=', // 32 bytes base64
  );
  static const String _hmacSecret = String.fromEnvironment(
    'HMAC_SECRET',
    defaultValue: 'PLACEHOLDER_HMAC_SECRET',
  );

  /// Generate a single encrypted barcode payload.
  static String generatePayload({
    required String deviceId,
    required String geoHash,
  }) {
    final epochSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // 1. Build raw payload
    final rawPayload = '$epochSeconds|$deviceId|$geoHash';

    // 2. Generate random IV (16 bytes)
    final random = Random.secure();
    final ivBytes = Uint8List.fromList(
      List.generate(16, (_) => random.nextInt(256)),
    );
    final ivBase64 = base64.encode(ivBytes);

    // 3. Proper AES-256-CBC encryption using `encrypt` package
    final key = encrypt.Key.fromBase64(_aesKeyBase64);
    final iv = encrypt.IV(ivBytes);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encryptedBase64 = encrypter.encrypt(rawPayload, iv: iv).base64;

    // 4. HMAC-SHA256 signature
    final hmacKey = utf8.encode(_hmacSecret);
    final hmac = Hmac(sha256, hmacKey);
    final digest = hmac.convert(utf8.encode(encryptedBase64));

    // 5. Final format: encryptedPayload.hmacSignature.ivBase64
    return '$encryptedBase64.${digest.toString()}.$ivBase64';
  }

  /// Stream of barcode payloads, refreshing every 30 seconds.
  static Stream<String> barcodeStream({
    required String deviceId,
    required String geoHash,
  }) {
    return Stream.periodic(
      const Duration(seconds: 30),
      (_) => generatePayload(deviceId: deviceId, geoHash: geoHash),
    ).asBroadcastStream();
  }

  /// Get remaining seconds until next refresh.
  static int getRemainingSeconds() {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return 30 - (now % 30);
  }
}
