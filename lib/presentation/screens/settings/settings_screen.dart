import 'package:flutter/material.dart';
import 'dart:io';
import '../../core/constants/app_colors.dart';
import '../../core/security/secure_storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _testnetEnabled = false;
  bool _biometricsEnabled = false;
  bool _2FAEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildNetworkSection(),
            const SizedBox(height: 24),
            _buildSecuritySection(),
            const SizedBox(height: 24),
            _buildComplianceSection(),
            const SizedBox(height: 24),
            _buildAboutSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text('Settings', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold));
  }

  Widget _buildNetworkSection() {
    return _buildSection(
      'Network',
      Icons.router,
      [
        _buildSwitch('Mainnet', 'Use mainnet for real transactions', !_testnetEnabled, (v) => setState(() => _testnetEnabled = !v)),
        _buildSwitch('Testnet', 'Use testnet for testing', _testnetEnabled, (v) => setState(() => _testnetEnabled = v)),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return _buildSection(
      'Security',
      Icons.security,
      [
        _buildSwitch('Biometrics', 'Use fingerprint/face to unlock', _biometricsEnabled, (v) => setState(() => _biometricsEnabled = v)),
        _buildSwitch('2FA', 'Two-factor authentication', _2FAEnabled, (v) => setState(() => _2FAEnabled = v)),
        _buildNavItem(Icons.key, 'Change PIN', () {}),
        _buildNavItem(Icons.password, 'View Recovery Phrase', _showSeedPhrase),
        _buildNavItem(Icons.blocked_usage, 'Clear Wallet', _clearWallet),
      ],
    );
  }

  Widget _buildComplianceSection() {
    return _buildSection(
      'Compliance',
      Icons.gavel,
      [
        _buildNavItem(Icons.flag, 'US (FinCEN)', () {}),
        _buildNavItem(Icons.flag, 'EU (AMLD5)', () {}),
        _buildNavItem(Icons.flag, 'UK (FCA)', () {}),
        _buildNavItem(Icons.flag, 'Canada (FINTRAC)', () {}),
        _buildNavItem(Icons.flag, 'South Korea (PFSO)', () {}),
      ],
    );
  }

  Widget _buildAboutSection() {
    return _buildSection(
      'About',
      Icons.info_outline,
      [
        _buildNavItem(Icons.description, 'Terms of Service', () {}),
        _buildNavItem(Icons.privacy_tip, 'Privacy Policy', () {}),
        _buildNavItem(Icons.article, 'Licenses', () {}),
        _buildNavItem(Icons.update, 'Version 1.0.0', () {}),
      ],
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Icon(icon, color: AppColors.primaryNeon), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.glassBorder)),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitch(String title, String subtitle, bool value, Function(bool) onChanged) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }

  Widget _buildNavItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
      onTap: onTap,
    );
  }

  void _showSeedPhrase() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recovery Phrase'),
        content: const Text('⚠️ Never share your recovery phrase! Anyone with this phrase can access your funds.', style: TextStyle(color: AppColors.warning)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () {}, child: const Text('Reveal')),
        ],
      ),
    );
  }

  void _clearWallet() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Wallet'),
        content: const Text('This will permanently delete your wallet. Make sure you have backed up your recovery phrase!'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(style: FilledButton.styleFrom(backgroundColor: AppColors.error), onPressed: () {}, child: const Text('Clear')),
        ],
      ),
    );
  }
}