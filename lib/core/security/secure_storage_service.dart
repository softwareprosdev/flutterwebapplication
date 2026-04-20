import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Keys
  static const String _privateKeyKey = 'wallet_private_key';
  static const String _seedPhraseKey = 'wallet_seed_phrase';
  static const String _pinHashKey = 'wallet_pin_hash';
  static const String _2faSecretKey = '2fa_secret';
  static const String _whitelistedAddressesKey = 'whitelisted_addresses';
  static const String _testnetEnabledKey = 'testnet_enabled';

  static Future<void> storePrivateKey(String privateKey) async {
    await _storage.write(key: _privateKeyKey, value: privateKey);
  }

  static Future<String?> getPrivateKey() async {
    return await _storage.read(key: _privateKeyKey);
  }

  static Future<void> deletePrivateKey() async {
    await _storage.delete(key: _privateKeyKey);
  }

  static Future<void> storeSeedPhrase(String encryptedSeed) async {
    await _storage.write(key: _seedPhraseKey, value: encryptedSeed);
  }

  static Future<String?> getSeedPhrase() async {
    return await _storage.read(key: _seedPhraseKey);
  }

  static Future<void> deleteSeedPhrase() async {
    await _storage.delete(key: _seedPhraseKey);
  }

  static Future<void> setWalletPin(String pin) async {
    final hash = _hashPin(pin);
    await _storage.write(key: _pinHashKey, value: hash);
  }

  static Future<bool> verifyWalletPin(String pin) async {
    final storedHash = await _storage.read(key: _pinHashKey);
    if (storedHash == null) return false;
    return storedHash == _hashPin(pin);
  }

  static Future<bool> hasWalletPin() async {
    final stored = await _storage.read(key: _pinHashKey);
    return stored != null;
  }

  static String _hashPin(String pin) {
    final bytes = utf8.encode(pin + 'CryptoMeccaWallet2026');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<void> store2FASecret(String secret) async {
    await _storage.write(key: _2faSecretKey, value: secret);
  }

  static Future<String?> get2FASecret() async {
    return await _storage.read(key: _2faSecretKey);
  }

  static Future<void> delete2FASecret() async {
    await _storage.delete(key: _2faSecretKey);
  }

  static Future<void> addWhitelistedAddress(String address, String label) async {
    final addresses = await getWhitelistedAddresses();
    addresses[address.toLowerCase()] = label;
    await _storage.write(
      key: _whitelistedAddressesKey,
      value: jsonEncode(addresses),
    );
  }

  static Future<Map<String, String>> getWhitelistedAddresses() async {
    final data = await _storage.read(key: _whitelistedAddressesKey);
    if (data == null) return {};
    return Map<String, String>.from(jsonDecode(data));
  }

  static Future<void> removeWhitelistedAddress(String address) async {
    final addresses = await getWhitelistedAddresses();
    addresses.remove(address.toLowerCase());
    await _storage.write(
      key: _whitelistedAddressesKey,
      value: jsonEncode(addresses),
    );
  }

  static Future<bool> isAddressWhitelisted(String address) async {
    final addresses = await getWhitelistedAddresses();
    return addresses.containsKey(address.toLowerCase());
  }

  static Future<void> setTestnetEnabled(bool enabled) async {
    await _storage.write(key: _testnetEnabledKey, value: enabled.toString());
  }

  static Future<bool> isTestnetEnabled() async {
    final value = await _storage.read(key: _testnetEnabledKey);
    return value == 'true';
  }

  static Future<void> clearAllData() async {
    await _storage.deleteAll();
  }

  static Future<bool> hasWallet() async {
    final key = await getPrivateKey();
    return key != null;
  }
}

class EncryptionService {
  static String encryptData(String data, String key) {
    final keyBytes = encrypt.Key.fromUtf8(key.padRight(32, '0').substring(0, 32));
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(keyBytes));
    final encrypted = encrypter.encrypt(data, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  static String decryptData(String encryptedData, String key) {
    try {
      final parts = encryptedData.split(':');
      if (parts.length != 2) throw const FormatException('Invalid format');
      
      final iv = encrypt.IV.fromBase64(parts[0]);
      final encrypted = encrypt.Encrypted.fromBase64(parts[1]);
      final keyBytes = encrypt.Key.fromUtf8(key.padRight(32, '0').substring(0, 32));
      final encrypter = encrypt.Encrypter(encrypt.AES(keyBytes));
      return encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      throw Exception('Decryption failed: $e');
    }
  }

  static String hashData(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static String generateSecureKey() {
    final random = encrypt.SecureRandom(32);
    return base64Encode(random.bytes);
  }
}