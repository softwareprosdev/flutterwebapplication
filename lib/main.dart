import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';

void main() {
  runApp(const CryptoMeccaApp());
}

class CryptoMeccaApp extends StatelessWidget {
  const CryptoMeccaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Mecca',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryNeon,
          secondary: AppColors.secondaryNeon,
          surface: AppColors.surface,
        ),
      ),
      home: const MainScreen(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          DashboardTab(),
          WalletTab(),
          MiningTab(),
          NewsTab(),
          ShopTab(),
          SettingsTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryNeon.withValues(alpha: 0.2),
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          NavigationDestination(icon: Icon(Icons.calculate), label: 'Mining'),
          NavigationDestination(icon: Icon(Icons.newspaper), label: 'News'),
          NavigationDestination(icon: Icon(Icons.shopping_bag), label: 'Shop'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Dashboard', style: TextStyle(color: AppColors.primaryNeon)),
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.currency_bitcoin, size: 80, color: AppColors.primaryNeon),
            SizedBox(height: 24),
            Text('CRYPTO MECCA', style: TextStyle(color: AppColors.primaryNeon, fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Enterprise Crypto Wallet', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class WalletTab extends StatelessWidget {
  const WalletTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Wallet', style: TextStyle(color: AppColors.primaryNeon)),
        elevation: 0,
      ),
      body: const Center(child: Text('Wallet', style: TextStyle(color: AppColors.textSecondary))),
    );
  }
}

class MiningTab extends StatelessWidget {
  const MiningTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Mining ROI', style: TextStyle(color: AppColors.primaryNeon)),
        elevation: 0,
      ),
      body: const Center(child: Text('Mining ROI Calculator', style: TextStyle(color: AppColors.textSecondary))),
    );
  }
}

class NewsTab extends StatelessWidget {
  const NewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('News', style: TextStyle(color: AppColors.primaryNeon)),
        elevation: 0,
      ),
      body: const Center(child: Text('Crypto News', style: TextStyle(color: AppColors.textSecondary))),
    );
  }
}

class ShopTab extends StatelessWidget {
  const ShopTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Shop', style: TextStyle(color: AppColors.primaryNeon)),
        elevation: 0,
      ),
      body: const Center(child: Text('Affiliate Shop', style: TextStyle(color: AppColors.textSecondary))),
    );
  }
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Settings', style: TextStyle(color: AppColors.primaryNeon)),
        elevation: 0,
      ),
      body: const Center(child: Text('Settings', style: TextStyle(color: AppColors.textSecondary))),
    );
  }
}