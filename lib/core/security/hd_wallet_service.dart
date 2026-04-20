import 'dart:typed_data';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:crypto/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:bitcoindart/bitcoindart.dart';

enum CryptoNetwork { mainnet, testnet, regtest }

enum CryptoType { bitcoin, ethereum, solana }

class HDWalletService {
  static bool isValidMnemonic(String mnemonic) {
    return bip39.validateMnemonic(mnemonic);
  }

  static String generateMnemonic({int strength = 256}) {
    final entropy = Uint8List(strength ~/ 8);
    for (var i = 0; i < entropy.length; i++) {
      entropy[i] = DateTime.now().microsecondsSinceEpoch % 256;
    }
    return bip39.generateMnemonic(strength: strength, entropy: entropy);
  }

  static String generateMnemonicSecure() {
    return bip39.generateMnemonic();
  }

  static WalletResult createWalletFromMnemonic(String mnemonic, CryptoNetwork network) {
    if (!isValidMnemonic(mnemonic)) {
      throw Exception('Invalid mnemonic phrase');
    }

    final seed = bip39.mnemonicToSeed(mnemonic);
    final master = bip32.BIP32.fromSeed(seed);

    // Bitcoin derivation
    final btcPath = "m/44'/0'/0'/0/0";
    final btcNode = master.derivePath(btcPath);
    final btcPrivateKey = btcNode.privateKey!;
    final btcPublicKey = btcNode.publicKey;

    final btcNetwork = network == CryptoNetwork.mainnet
        ? Networks.bitcoin
        : Networks.bitcoinTestnet;

    final btcAddress = P2WPKH(
      data: P2WPKHData(
        pubkeyHash: _hash160(btcPublicKey),
      ),
      type: network == CryptoNetwork.mainnet ? NetworkType.production : NetworkType.testnet,
    ).address!;

    // Ethereum derivation
    final ethPath = "m/44'/60'/0'/0/0";
    final ethNode = master.derivePath(ethPath);
    final ethPrivateKey = _bytesToHex(ethNode.privateKey!);
    final ethCredentials = EthPrivateKey.fromHex(ethPrivateKey);
    final ethAddress = ethCredentials.address;

    return WalletResult(
      mnemonic: mnemonic,
      seed: _bytesToHex(seed),
      bitcoin: BitcoinWalletData(
        privateKey: _bytesToHex(btcPrivateKey),
        publicKey: _bytesToHex(btcPublicKey),
        address: btcAddress,
        path: btcPath,
      ),
      ethereum: EthereumWalletData(
        privateKey: ethPrivateKey,
        address: ethAddress.hex,
        path: ethPath,
      ),
    );
  }

  static String deriveAddress(CryptoType type, String privateKey, CryptoNetwork network) {
    switch (type) {
      case CryptoType.bitcoin:
        final keyPair = ECPair.fromPrivateKey(
          _hexToBytes(privateKey),
          network: network == CryptoNetwork.mainnet
              ? Networks.bitcoin
              : Networks.bitcoinTestnet,
        );
        return keyPair.address!;
      case CryptoType.ethereum:
        final creds = EthPrivateKey.fromHex(privateKey);
        return creds.address.hex;
      case CryptoType.solana:
        return 'Solana address derivation not implemented';
    }
  }

  static String signTransaction(CryptoType type, String privateKey, String message) {
    switch (type) {
      case CryptoType.bitcoin:
        final keyPair = ECPair.fromPrivateKey(_hexToBytes(privateKey));
        final signature = keyPair.sign(_hash256(message));
        return _bytesToHex(signature);
      case CryptoType.ethereum:
        final creds = EthPrivateKey.fromHex(privateKey);
        final signature = creds.signMessage(message);
        return signature;
      case CryptoType.solana:
        return 'Solana signing not implemented';
    }
  }

  static List<AddressIndex> getAddressHistory(String xpub, int start, int count) {
    return List.generate(count, (i) => AddressIndex(index: start + i));
  }

  static Uint8List _hash160(Uint8List data) {
    final h1 = sha256.convert(data);
    final h2 = ripemd160.convert(h1.bytes);
    return Uint8List.fromList(h2.bytes);
  }

  static Uint8List _hash256(String data) {
    final bytes = data.codeUnits;
    final h1 = sha256.convert(bytes);
    final h2 = sha256.convert(h1.bytes);
    return Uint8List.fromList(h2.bytes);
  }

  static String _bytesToHex(Uint8List bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  static Uint8List _hexToBytes(String hex) {
    return Uint8List.fromList([
      for (var i = 0; i < hex.length; i += 2)
        int.parse(hex.substring(i, i + 2), radix: 16),
    ]);
  }
}

class WalletResult {
  final String mnemonic;
  final String seed;
  final BitcoinWalletData bitcoin;
  final EthereumWalletData ethereum;

  WalletResult({
    required this.mnemonic,
    required this.seed,
    required this.bitcoin,
    required this.ethereum,
  });
}

class BitcoinWalletData {
  final String privateKey;
  final String publicKey;
  final String address;
  final String path;

  BitcoinWalletData({
    required this.privateKey,
    required this.publicKey,
    required this.address,
    required this.path,
  });
}

class EthereumWalletData {
  final String privateKey;
  final String address;
  final String path;

  EthereumWalletData({
    required this.privateKey,
    required this.address,
    required this.path,
  });
}

class AddressIndex {
  final int index;
  final String? address;

  AddressIndex({required this.index, this.address});
}