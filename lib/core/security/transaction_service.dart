import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'secure_storage_service.dart';

class TransactionVerificationService {
  static const int _maxWhitelistedAddresses = 50;
  static const double _maxTransactionUSD = 10000;
  static const double _highValueThresholdUSD = 1000;

  static Future<TransactionVerification> verifyTransaction({
    required String fromAddress,
    required String toAddress,
    required String amount,
    required String currency,
    required double usdValue,
    bool isTestTransaction = false,
  }) async {
    final warnings = <String>[];
    final isPassed = true;

    // Check if address is whitelisted
    final isToWhitelisted = await SecureStorageService.isAddressWhitelisted(toAddress);
    if (!isToWhitelisted && !isTestTransaction) {
      warnings.add('Address not in whitelist - review recommended');
    }

    // Check transaction value limits
    if (usdValue > _maxTransactionUSD && !isTestTransaction) {
      warnings.add('Transaction exceeds maximum value of \$$_maxTransactionUSD');
    }

    // High value warning
    if (usdValue > _highValueThresholdUSD) {
      warnings.add('High value transaction - 2FA required');
    }

    // Verify address format
    if (!_isValidAddressFormat(toAddress, currency)) {
      return TransactionVerification(
        isPassed: false,
        isTestTransaction: isTestTransaction,
        errors: ['Invalid address format for $currency'],
      );
    }

    // Check for known scam patterns
    final scamWarning = _checkScamPatterns(toAddress);
    if (scamWarning != null) {
      warnings.add(scamWarning);
    }

    // Generate verification ID
    final verificationId = _generateVerificationId();

    return TransactionVerification(
      isPassed: isPassed,
      isTestTransaction: isTestTransaction,
      warnings: warnings,
      verificationId: verificationId,
      requires2FA: usdValue > _highValueThresholdUSD && !isTestTransaction,
      riskScore: _calculateRiskScore(usdValue, isToWhitelisted, isTestTransaction),
    );
  }

  static bool _isValidAddressFormat(String address, String currency) {
    switch (currency.toLowerCase()) {
      case 'btc':
        return _isValidBitcoinAddress(address);
      case 'eth':
        return _isValidEthereumAddress(address);
      case 'sol':
        return _isValidSolanaAddress(address);
      default:
        return address.length >= 26 && address.length <= 62;
    }
  }

  static bool _isValidBitcoinAddress(String address) {
    // Basic BTC address validation
    if (address.startsWith('1') || address.startsWith('3')) {
      return address.length >= 26 && address.length <= 35;
    }
    if (address.startsWith('bc1')) {
      return address.length >= 42 && address.length <= 62;
    }
    if (address.startsWith('m') || address.startsWith('n')) {
      return address.length >= 26 && address.length <= 35;
    }
    return false;
  }

  static bool _isValidEthereumAddress(String address) {
    if (!address.startsWith('0x')) return false;
    if (address.length != 42) return false;
    return RegExp(r'^0x[a-fA-F0-9]{40}$').hasMatch(address);
  }

  static bool _isValidSolanaAddress(String address) {
    return address.length >= 32 && address.length <= 44;
  }

  static String? _checkScamPatterns(String address) {
    // Check for known scam address patterns
    final lowerAddress = address.toLowerCase();
    
    // Check for very similar to common addresses (typosquatting)
    final suspiciousPatterns = [
      '0x0000000000000000000000000000000000000000',
      '0x000000000000000000000000000000000000dEaD',
    ];
    
    if (suspiciousPatterns.contains(lowerAddress)) {
      return 'Address is a burn address - funds will be lost';
    }
    
    return null;
  }

  static int _calculateRiskScore(double usdValue, bool isWhitelisted, bool isTest) {
    if (isTest) return 0;
    
    int score = 0;
    
    // Value-based risk
    if (usdValue > 5000) score += 30;
    else if (usdValue > 1000) score += 15;
    else score += 5;
    
    // Whitelist status
    if (!isWhitelisted) score += 40;
    
    // Additional risk factors can be added here
    return score.clamp(0, 100);
  }

  static String _generateVerificationId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random.secure().nextInt(999999);
    return 'TX${timestamp}$random';
  }

  static Future<WhitelistResult> addToWhitelist(String address, String label) async {
    final addresses = await SecureStorageService.getWhitelistedAddresses();
    
    if (addresses.length >= _maxWhitelistedAddresses) {
      return WhitelistResult(
        success: false,
        error: 'Maximum $_maxWhitelistedAddresses addresses allowed',
      );
    }

    await SecureStorageService.addWhitelistedAddress(address, label);
    
    return WhitelistResult(
      success: true,
      addressCount: addresses.length + 1,
    );
  }

  static Future<WhitelistResult> removeFromWhitelist(String address) async {
    await SecureStorageService.removeWhitelistedAddress(address);
    final addresses = await SecureStorageService.getWhitelistedAddresses();
    
    return WhitelistResult(
      success: true,
      addressCount: addresses.length,
    );
  }

  static Future<List<WhitelistedAddress>> getWhitelist() async {
    final addresses = await SecureStorageService.getWhitelistedAddresses();
    return addresses.entries
        .map((e) => WhitelistedAddress(address: e.key, label: e.value))
        .toList();
  }

  static Future<TestTransactionResult> executeTestTransaction({
    required String fromAddress,
    required String toAddress,
    required String amount,
    required String currency,
  }) async {
    // Simulate test transaction
    await Future.delayed(const Duration(seconds: 1));
    
    return TestTransactionResult(
      success: true,
      transactionHash: '0x${sha256.convert('$fromAddress$toAddress$amount'.codeUnits).toString().substring(0, 64)}',
      amount: amount,
      currency: currency,
      timestamp: DateTime.now(),
    );
  }
}

class TransactionVerification {
  final bool isPassed;
  final bool isTestTransaction;
  final List<String> warnings;
  final List<String> errors;
  final String? verificationId;
  final bool requires2FA;
  final int riskScore;

  TransactionVerification({
    required this.isPassed,
    required this.isTestTransaction,
    this.warnings = const [],
    this.errors = const [],
    this.verificationId,
    this.requires2FA = false,
    this.riskScore = 0,
  });
}

class WhitelistResult {
  final bool success;
  final String? error;
  final int addressCount;

  WhitelistResult({
    required this.success,
    this.error,
    this.addressCount = 0,
  });
}

class WhitelistedAddress {
  final String address;
  final String label;
  final DateTime addedAt;

  WhitelistedAddress({
    required this.address,
    required this.label,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();
}

class TestTransactionResult {
  final bool success;
  final String? transactionHash;
  final String? error;
  final String amount;
  final String currency;
  final DateTime timestamp;

  TestTransactionResult({
    required this.success,
    this.transactionHash,
    this.error,
    required this.amount,
    required this.currency,
    required this.timestamp,
  });
}