import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildCategories(),
            Expanded(child: _buildProducts()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Shop', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.accentLime, AppColors.primaryNeon]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.link, size: 16, color: AppColors.background),
                    SizedBox(width: 4),
                    Text('Affiliate', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.background)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.warning, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'We earn a commission on links - use our links to support the app!',
                    style: TextStyle(color: AppColors.warning, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final categories = ['All', 'Hardware Wallets', 'Mining', 'Cold Storage', 'Accessories'];
    
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: categories.map((cat) {
          final isSelected = cat == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryNeon.withValues(alpha: 0.15) : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? AppColors.primaryNeon : AppColors.glassBorder),
              ),
              child: Text(cat, style: TextStyle(
                color: isSelected ? AppColors.primaryNeon : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              )),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProducts() {
    final products = [
      {'name': 'Ledger Nano X', 'category': 'Hardware Wallets', 'price': '\$149', 'rating': 4.8, 'retailer': 'Ledger', 'link': 'https://ledger.com'},
      {'name': 'Ledger Nano S Plus', 'category': 'Hardware Wallets', 'price': '\$79', 'rating': 4.7, 'retailer': 'Ledger', 'link': 'https://ledger.com'},
      {'name': 'Trezor Model T', 'category': 'Hardware Wallets', 'price': '\$239', 'rating': 4.7, 'retailer': 'Trezor', 'link': 'https://trezor.io'},
      {'name': 'Antminer S19 Pro', 'category': 'Mining', 'price': '\$2,499', 'rating': 4.9, 'retailer': 'Bitmain', 'link': 'https://bitmain.com'},
      {'name': 'Cryptosteel Capsule', 'category': 'Cold Storage', 'price': '\$29', 'rating': 4.9, 'retailer': 'Cryptosteel', 'link': 'https://cryptosteel.com'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final isSelected = _selectedCategory == 'All' || _selectedCategory == product['category'];
    if (!isSelected && _selectedCategory != 'All') return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              product['category'] == 'Hardware Wallets' ? Icons.account_balance_wallet :
              product['category'] == 'Mining' ? Icons.memory :
              product['category'] == 'Cold Storage' ? Icons.ac_unit : Icons.build,
              color: AppColors.primaryNeon,
              size: 36,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryNeon.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(product['category'], style: TextStyle(color: AppColors.primaryNeon, fontSize: 10)),
                ),
                const SizedBox(height: 4),
                Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    Text(' ${product['rating']}', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    const SizedBox(width: 8),
                    Text('${product['retailer']}', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(product['price'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryNeon)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _openAffiliateLink(product['link']),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.primaryNeon, AppColors.secondaryNeon]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Buy', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.background)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openAffiliateLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}