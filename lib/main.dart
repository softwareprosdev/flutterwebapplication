import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_colors.dart';
import 'core/security/secure_storage_service.dart';
import 'presentation/screens/dashboard/dashboard_screen.dart';
import 'presentation/screens/wallet/wallet_screen.dart';
import 'presentation/screens/mining/mining_roi_screen.dart';
import 'presentation/screens/news/news_screen.dart';
import 'presentation/screens/shop/shop_screen.dart';
import 'presentation/screens/settings/settings_screen.dart';
import 'presentation/screens/wallet/create_wallet_screen.dart';
import 'presentation/bloc/wallet_bloc.dart';
import 'presentation/bloc/portfolio_bloc.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize secure storage
  await SecureStorageService.isTestnetEnabled();
  
  // Initialize RevenueCat
  await _initializeRevenueCat();
  
  // Setup dependency injection
  _setupDI();
  
  // Set system UI
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.surface,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  
  runApp(const CryptoMeccaApp());
}

Future<void> _initializeRevenueCat() async {
  try {
    if (Platform.isIOS || Platform.isAndroid) {
      await Purchases.configure(PurchasesConfiguration('test_VvNEsCmkFVgSepDBnuRAsZMybXi'));
    }
  } catch (e) {
    debugPrint('RevenueCat: $e');
  }
}

void _setupDI() {
  final getIt = GetIt.instance;
  // Register services
}

class CryptoMeccaApp extends StatelessWidget {
  const CryptoMeccaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WalletBloc()..add(LoadWallet())),
        BlocProvider(create: (_) => PortfolioBloc()..add(LoadPortfolio())),
      ],
      child: MaterialApp(
        title: 'Crypto Mecca',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            if (state is WalletLoading) {
              return const SplashScreen();
            }
            if (state is WalletNotCreated) {
              return const CreateWalletScreen();
            }
            return const MainScreen();
          },
        ),
        routes: {
          '/dashboard': (_) => const DashboardScreen(),
          '/wallet': (_) => const WalletScreen(),
          '/mining': (_) => const MiningROIScreen(),
          '/news': (_) => const NewsScreen(),
          '/shop': (_) => const ShopScreen(),
          '/settings': (_) => const SettingsScreen(),
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final _screens = const [
    DashboardScreen(),
    WalletScreen(),
    MiningROIScreen(),
    NewsScreen(),
    ShopScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.glassBorder, width: 0.5),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
            NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Wallet'),
            NavigationDestination(icon: Icon(Icons.calculate_outlined), label: 'Mining'),
            NavigationDestination(icon: Icon(Icons.newspaper_outlined), label: 'News'),
            NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), label: 'Shop'),
            NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.primaryNeon, AppColors.secondaryNeon],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryNeon.withValues(alpha: 0.4),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(Icons.currency_bitcoin, size: 60, color: AppColors.background),
            ),
            const SizedBox(height: 32),
            const Text(
              'CRYPTO MECCA',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                color: AppColors.primaryNeon,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Enterprise Wallet',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 48),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primaryNeon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}