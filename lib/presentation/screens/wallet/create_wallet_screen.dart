import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../bloc/wallet_bloc.dart';

class CreateWalletScreen extends StatefulWidget {
  const CreateWalletScreen({super.key});

  @override
  State<CreateWalletScreen> createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends State<CreateWalletScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  String _seedPhrase = '';
  final _importController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (page) => setState(() => _currentPage = page),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildWelcome(),
            _buildCreateOrImport(),
            _buildCreateWallet(),
            _buildImportWallet(),
            _buildSetPin(),
            _buildSuccess(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcome() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.primaryNeon, AppColors.secondaryNeon]),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: AppColors.primaryNeon.withValues(alpha: 0.4), blurRadius: 30, spreadRadius: 5)],
            ),
            child: const Icon(Icons.currency_bitcoin, size: 60, color: AppColors.background),
          ),
          const SizedBox(height: 32),
          const Text('CRYPTO MECCA', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 4, color: AppColors.primaryNeon)),
          const SizedBox(height: 16),
          Text('Non-custodial crypto wallet', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNeon,
                foregroundColor: AppColors.background,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Get Started', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateOrImport() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Spacer(),
          _buildOptionCard(Icons.add_circle, 'Create New Wallet', 'Generate a new secure wallet', () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut)),
          const SizedBox(height: 16),
          _buildOptionCard(Icons.upload_file, 'Import Wallet', 'Restore with recovery phrase', () => _pageController.jumpToPage(3)),
          const Spacer(),
          Text('By continuing, you agree to our Terms of Service', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildOptionCard(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryNeon.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppColors.primaryNeon, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateWallet() {
    if (_seedPhrase.isEmpty) {
      context.read<WalletBloc>().add(CreateWallet());
    }
    
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Spacer(),
          const Text('Your Recovery Phrase', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Write these words in order and store safely', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.warning),
            ),
            child: Row(
              children: [Icon(Icons.warning, color: AppColors.warning), const SizedBox(width: 12), Expanded(child: Text('Never share this phrase! Anyone with it can access your funds.', style: TextStyle(color: AppColors.warning)))],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.glassBorder)),
            child: _seedPhrase.isEmpty 
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryNeon))
                : Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _seedPhrase.split(' ').asMap().entries.map((e) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${e.key + 1}.', style: TextStyle(color: AppColors.primaryNeon, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Text(e.value),
                        ],
                      ),
                    )).toList(),
                  ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _seedPhrase.isEmpty ? null : () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
              child: const Text('I\'ve Saved My Phrase', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportWallet() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Spacer(),
          const Text('Import Wallet', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Enter your 12 or 24 word recovery phrase', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          TextField(
            controller: _importController,
            maxLines: 4,
            style: const TextStyle(fontFamily: 'monospace'),
            decoration: InputDecoration(
              hintText: 'word1 word2 word3 ...',
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.glassBorder)),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (_importController.text.isNotEmpty) {
                  context.read<WalletBloc>().add(ImportWallet(mnemonic: _importController.text));
                  _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                }
              },
              child: const Text('Import Wallet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildSetPin() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Spacer(),
          const Text('Set PIN', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Create a 6-digit PIN to secure your wallet', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
              child: const Text('Continue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, color: AppColors.success, size: 64),
          ),
          const SizedBox(height: 32),
          const Text('Wallet Created!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text('Your wallet is ready to use', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Continue to App', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _importController.dispose();
    super.dispose();
  }
}