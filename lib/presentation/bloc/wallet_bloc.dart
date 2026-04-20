import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../core/security/secure_storage_service.dart';
import '../../core/security/hd_wallet_service.dart';

// Events
abstract class WalletEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadWallet extends WalletEvent {}

class CreateWallet extends WalletEvent {
  final String? mnemonic;
  CreateWallet({this.mnemonic});
  @override
  List<Object?> get props => [mnemonic];
}

class ImportWallet extends WalletEvent {
  final String mnemonic;
  ImportWallet({required this.mnemonic});
  @override
  List<Object?> get props => [mnemonic];
}

class SetPin extends WalletEvent {
  final String pin;
  SetPin({required this.pin});
  @override
  List<Object?> get props => [pin];
}

class VerifyPin extends WalletEvent {
  final String pin;
  VerifyPin({required this.pin});
  @override
  List<Object?> get props => [pin];
}

// States
abstract class WalletState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletNotCreated extends WalletState {
  final bool hasPin;
  WalletNotCreated({this.hasPin = false});
  @override
  List<Object?> get props => [hasPin];
}

class WalletUnlocked extends WalletState {
  final String btcAddress;
  final String ethAddress;
  final double? btcBalance;
  final double? ethBalance;
  final bool has2FA;
  
  WalletUnlocked({
    required this.btcAddress,
    required this.ethAddress,
    this.btcBalance,
    this.ethBalance,
    this.has2FA = false,
  });
  
  @override
  List<Object?> get props => [btcAddress, ethAddress, btcBalance, ethBalance, has2FA];
}

class WalletLocked extends WalletState {
  final bool hasPin;
  WalletLocked({this.hasPin = true});
  @override
  List<Object?> get props => [hasPin];
}

class WalletError extends WalletState {
  final String message;
  WalletError({required this.message});
  @override
  List<Object?> get props => [message];
}

// BLoC
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletInitial()) {
    on<LoadWallet>(_onLoadWallet);
    on<CreateWallet>(_onCreateWallet);
    on<ImportWallet>(_onImportWallet);
    on<SetPin>(_onSetPin);
    on<VerifyPin>(_onVerifyPin);
  }

  Future<void> _onLoadWallet(LoadWallet event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    try {
      final hasWallet = await SecureStorageService.hasWallet();
      final hasPin = await SecureStorageService.hasWalletPin();
      
      if (!hasWallet) {
        emit(WalletNotCreated(hasPin: hasPin));
      } else if (hasPin) {
        emit(WalletLocked(hasPin: hasPin));
      } else {
        await _loadUnlockedWallet(emit);
      }
    } catch (e) {
      emit(WalletError(message: e.toString()));
    }
  }

  Future<void> _onCreateWallet(CreateWallet event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    try {
      final mnemonic = event.mnemonic ?? HDWalletService.generateMnemonicSecure();
      final wallet = HDWalletService.createWalletFromMnemonic(
        mnemonic,
        CryptoNetwork.mainnet,
      );
      
      // Store encrypted
      await SecureStorageService.storePrivateKey(wallet.bitcoin.privateKey);
      await SecureStorageService.storeSeedPhrase(
        EncryptionService.encryptData(mnemonic, 'wallet_seed_key'),
      );
      
      await _loadUnlockedWallet(emit);
    } catch (e) {
      emit(WalletError(message: e.toString()));
    }
  }

  Future<void> _onImportWallet(ImportWallet event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    try {
      if (!HDWalletService.isValidMnemonic(event.mnemonic)) {
        emit(WalletError(message: 'Invalid wallet phrase'));
        return;
      }
      
      final wallet = HDWalletService.createWalletFromMnemonic(
        event.mnemonic,
        CryptoNetwork.mainnet,
      );
      
      await SecureStorageService.storePrivateKey(wallet.bitcoin.privateKey);
      await SecureStorageService.storeSeedPhrase(
        EncryptionService.encryptData(event.mnemonic, 'wallet_seed_key'),
      );
      
      await _loadUnlockedWallet(emit);
    } catch (e) {
      emit(WalletError(message: e.toString()));
    }
  }

  Future<void> _onSetPin(SetPin event, Emitter<WalletState> emit) async {
    await SecureStorageService.setWalletPin(event.pin);
    await _loadUnlockedWallet(emit);
  }

  Future<void> _onVerifyPin(VerifyPin event, Emitter<WalletState> emit) async {
    final isValid = await SecureStorageService.verifyWalletPin(event.pin);
    if (isValid) {
      await _loadUnlockedWallet(emit);
    } else {
      emit(WalletError(message: 'Invalid PIN'));
    }
  }

  Future<void> _loadUnlockedWallet(Emitter<WalletState> emit) async {
    final has2FA = await SecureStorageService.get2FASecret() != null;
    
    emit(WalletUnlocked(
      btcAddress: 'bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh',
      ethAddress: '0x742d35Cc6634C0532925a3b844F4549aa828f7B26',
      btcBalance: 0.0,
      ethBalance: 0.0,
      has2FA: has2FA,
    ));
  }
}