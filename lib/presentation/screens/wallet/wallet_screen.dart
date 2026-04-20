import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/constants/app_colors.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String _selectedCoin = 'BTC';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildCoinSelector(),
              const SizedBox(height: 24),
              _buildAddressCard(),
              const SizedBox(height: 24),
              _buildActions(),
              const SizedBox(height: 24),
              _buildBalanceCard(),
              const SizedBox(height: 24),
              _buildRecentTransactions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Wallet', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            children: [
              Icon(Icons.circle, size: 8, color: AppColors.success),
              const SizedBox(width: 6),
              Text('Mainnet', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCoinSelector() {
    final coins = [
      {'symbol': 'BTC', 'name': 'Bitcoin', 'icon': '₿'},
      {'symbol': 'ETH', 'name': 'Ethereum', 'icon': 'Ξ'},
      {'symbol': 'SOL', 'name': 'Solana', 'icon': '◎'},
    ];

    return Row(
      children: coins.map((coin) {
        final isSelected = coin['symbol'] == _selectedCoin;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedCoin = coin['symbol'] as String),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppColors.primaryNeon.withValues(alpha: 0.15)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected 
                      ? AppColors.primaryNeon 
                      : AppColors.glassBorder,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected 
                    ? [BoxShadow(
                        color: AppColors.primaryNeon.withValues(alpha: 0.2),
                        blurRadius: 12,
                      )]
                    : null,
              ),
              child: Column(
                children: [
                  Text(coin['icon'] as String, style: TextStyle(
                    fontSize: 24,
                    color: isSelected ? AppColors.primaryNeon : AppColors.textSecondary,
                  )),
                  const SizedBox(height: 4),
                  Text(coin['symbol'] as String, style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.primaryNeon : AppColors.textSecondary,
                  )),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAddressCard() {
    final address = 'bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh';
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$_selectedCoin Address', style: TextStyle(color: AppColors.textSecondary)),
              IconButton(
                icon: Icon(Icons.qr_code, color: AppColors.primaryNeon),
                onPressed: () => _showQRCode(context, address),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    address,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: address));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: const Text('Address copied!'), backgroundColor: AppColors.success),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(Icons.arrow_downward, 'Receive', AppColors.primaryNeon, () {}),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(Icons.arrow_upward, 'Send', AppColors.secondaryNeon, () {}),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(Icons.swap_horiz, 'Swap', AppColors.accentLime, () {}),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.05)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 12)],
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    final balances = {
      'BTC': {'available': 0.5, 'locked': 0.0},
      'ETH': {'available': 2.0, 'locked': 0.0},
      'SOL': {'available': 25.0, 'locked': 0.0},
    };
    
    final balance = balances[_selectedCoin]!;
    final available = balance['available'] as double;
    final locked = balance['locked'] as double;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.surfaceGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Balance', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$available $_selectedCoin', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              if (locked > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('${locked.toString()} locked', style: TextStyle(color: AppColors.warning, fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('In USD', style: TextStyle(color: AppColors.textSecondary)),
              Text('\$${(available * 42500).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    final transactions = [
      {'type': 'received', 'amount': '0.1 BTC', 'from': 'bc1q...8fjk', 'time': '2h ago'},
      {'type': 'sent', 'amount': '0.05 BTC', 'to': 'bc1q...9abc', 'time': '1d ago'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...transactions.map((tx) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (tx['type'] == 'received' ? AppColors.success : AppColors.error).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  tx['type'] == 'received' ? Icons.arrow_downward : Icons.arrow_upward,
                  color: tx['type'] == 'received' ? AppColors.success : AppColors.error,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tx['amount'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      tx['type'] == 'received' 
                          ? 'From: ${tx['from']}'
                          : 'To: ${tx['to']}',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(tx['time'] as String, style: TextStyle(color: AppColors.textMuted)),
            ],
          ),
        )),
      ],
    );
  }

  void _showQRCode(BuildContext context, String address) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            Text('$_selectedCoin Address', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: QrImageView(data: address, size: 200),
            ),
            const SizedBox(height: 24),
            Text(address, style: const TextStyle(fontFamily: 'monospace')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: address));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied!')));
              },
              child: const Text('Copy Address'),
            ),
          ],
        ),
      ),
    );
  }
}