import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final _news = [
    {'title': 'Bitcoin Surges Past \$45K as Institutional Interest Grows', 'source': 'CoinDesk', 'time': '2h ago', 'tag': 'BTC'},
    {'title': 'Ethereum Staking Yields Attract More Validators', 'source': 'Bloomberg', 'time': '4h ago', 'tag': 'ETH'},
    {'title': 'SEC Delays Bitcoin ETF Decision Again', 'source': 'Reuters', 'time': '6h ago', 'tag': 'Regulation'},
    {'title': 'DeFi Total Value Locked Reaches New High', 'source': 'DeFi Pulse', 'time': '8h ago', 'tag': 'DeFi'},
    {'title': 'Solana Network Sees 50% Increase in Transactions', 'source': 'The Block', 'time': '12h ago', 'tag': 'SOL'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(child: _buildNewsList()),
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
          const Text('Crypto News', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text('Live', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _news.length,
      itemBuilder: (context, index) {
        final item = _news[index];
        return _buildNewsCard(item);
      },
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.surfaceGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getTagColor(item['tag']).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(item['tag'], style: TextStyle(color: _getTagColor(item['tag']), fontWeight: FontWeight.bold, fontSize: 10)),
              ),
              const Spacer(),
              Icon(Icons.circle, size: 8, color: AppColors.success),
              const SizedBox(width: 4),
              Text(item['time'], style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.source, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(item['source'], style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Color _getTagColor(String tag) {
    switch (tag) {
      case 'BTC': return AppColors.primaryNeon;
      case 'ETH': return AppColors.secondaryNeon;
      case 'SOL': return AppColors.accentLime;
      case 'DeFi': return AppColors.tertiaryNeon;
      case 'Regulation': return AppColors.warning;
      default: return AppColors.textSecondary;
    }
  }
}