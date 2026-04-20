import 'dart:math';
import 'package:otp/otp.dart';
import 'package:crypto/crypto.dart';

enum TwoFactorMethod { totp, email, sms, backupCode }

class TwoFactorService {
  static const int _codeLength = 6;
  static const int _periodSeconds = 30;
  static const int _window = 1;

  static String generateSecret({String? email}) {
    final secret = _generateRandomSecret(20);
    if (email != null) {
      return OTP.createSecret(
        secret,
        name: 'CryptoMecca',
        issuer: 'CryptoMeccaWallet',
        algorithm: Algorithm.SHA1,
        digits: _codeLength,
        interval: _periodSeconds,
      );
    }
    return secret;
  }

  static String get provisioningUri(String secret, String account) {
    return OTP.createSecret(
      secret,
      name: account,
      issuer: 'CryptoMeccaWallet',
      algorithm: Algorithm.SHA1,
      digits: _codeLength,
      interval: _periodSeconds,
    );
  }

  static bool verifyCode(String secret, String code, {DateTime? time}) {
    final now = time ?? DateTime.now();
    
    for (int i = -_window; i <= _window; i++) {
      final timestamp = now.add(Duration(seconds: i * _periodSeconds));
      final expected = _generateCode(secret, timestamp);
      if (expected == code) return true;
    }
    return false;
  }

  static String getCurrentCode(String secret) {
    return _generateCode(secret, DateTime.now());
  }

  static String _generateCode(String secret, DateTime time) {
    try {
      return OTP.generateTOTPCode(
        secret,
        time.millisecondsSinceEpoch,
        length: _codeLength,
        interval: _periodSeconds,
        algorithm: Algorithm.SHA1,
        isGoogle: true,
      );
    } catch (e) {
      return '000000';
    }
  }

  static String _generateRandomSecret(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    final random = Random.secure();
    return List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();
  }

  static List<String> generateBackupCodes({int count = 10}) {
    final codes = <String>[];
    final random = Random.secure();
    
    for (int i = 0; i < count; i++) {
      final code = List.generate(8, (_) {
        final n = random.nextInt(36);
        return n < 10 ? n.toString() : String.fromCharCode(65 + n - 10);
      }).join();
      codes.add('${code.substring(0, 4)}-${code.substring(4)}');
    }
    
    return codes;
  }

  static String hashBackupCode(String code, String salt) {
    final bytes = '${code.toUpperCase()}${salt}'.codeUnits;
    return sha256.convert(bytes).toString();
  }

  static Future<bool> sendVerificationEmail(String email) async {
    // Integrate with email service (SendGrid, AWS SES, etc.)
    return true;
  }

  static Future<bool> sendVerificationSMS(String phone) async {
    // Integrate with SMS service (Twilio, AWS SNS, etc.)
    return true;
  }

  static Future<bool> sendVerificationPush(String deviceToken) async {
    // Integrate with Firebase Cloud Messaging
    return true;
  }
}

class TwoFactorConfig {
  final TwoFactorMethod primaryMethod;
  final TwoFactorMethod backupMethod;
  final bool isEnabled;
  final DateTime? lastVerifiedAt;
  final int failedAttempts;
  final DateTime? lockedUntil;

  TwoFactorConfig({
    required this.primaryMethod,
    required this.backupMethod,
    this.isEnabled = false,
    this.lastVerifiedAt,
    this.failedAttempts = 0,
    this.lockedUntil,
  });

  bool get isLocked => lockedUntil != null && DateTime.now().isBefore(lockedUntil!);

  TwoFactorConfig copyWith({
    TwoFactorMethod? primaryMethod,
    TwoFactorMethod? backupMethod,
    bool? isEnabled,
    DateTime? lastVerifiedAt,
    int? failedAttempts,
    DateTime? lockedUntil,
  }) {
    return TwoFactorConfig(
      primaryMethod: primaryMethod ?? this.primaryMethod,
      backupMethod: backupMethod ?? this.backupMethod,
      isEnabled: isEnabled ?? this.isEnabled,
      lastVerifiedAt: lastVerifiedAt ?? this.lastVerifiedAt,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockedUntil: lockedUntil ?? this.lockedUntil,
    );
  }
}

class AuthVerifier {
  static const int _maxAttempts = 5;
  static const int _lockoutMinutes = 15;

  static Future<TwoFactorResult> verify({
    required TwoFactorMethod method,
    required String secret,
    required String code,
  }) async {
    if (method == TwoFactorMethod.totp) {
      final isValid = TwoFactorService.verifyCode(secret, code);
      return TwoFactorResult(
        success: isValid,
        method: method,
        timestamp: DateTime.now(),
      );
    }
    
    return TwoFactorResult(
      success: false,
      method: method,
      error: 'Method not implemented',
      timestamp: DateTime.now(),
    );
  }
}

class TwoFactorResult {
  final bool success;
  final TwoFactorMethod method;
  final String? error;
  final DateTime timestamp;
  final String? backupCode;

  TwoFactorResult({
    required this.success,
    required this.method,
    this.error,
    required this.timestamp,
    this.backupCode,
  });
}