import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class MiningROIScreen extends StatefulWidget {
  const MiningROIScreen({super.key});

  @override
  State<MiningROIScreen> createState() => _MiningROIScreenState();
}

class _MiningROIScreenState extends State<MiningROIScreen> {
  final _hashrateController = TextEditingController(text: '100');
  final _powerController = TextEditingController(text: '3500');
  final _electricityController = TextEditingController(text: '0.08');
  
  double _hashrate = 100;
  double _power = 3500;
  double _electricityCost = 0.08;
  int _days = 30;
  
  double get _dailyRevenue => (_hashrate * 24 * 0.00000001 * 50);
  double get _dailyCost => (_power / 1000 * _electricityCost * 24);
  double get _dailyProfit => _dailyRevenue - _dailyCost;
  double get _monthlyROI => _dailyProfit * _days / (_power * 0.5) * 100;

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
              _buildCalculatorInputs(),
              const SizedBox(height: 24),
              _buildResultsPanel(),
              const SizedBox(height: 24),
              _buildHardwareSuggestions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'Mining ROI Calculator',
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildCalculatorInputs() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSliderInput('Hash Rate (TH/s)', _hashrate, 1, 200, (v) => setState(() => _hashrate = v)),
          const SizedBox(height: 20),
          _buildSliderInput('Power (Watts)', _power, 100, 5000, (v) => setState(() => _power = v)),
          const SizedBox(height: 20),
          _buildSliderInput('Electricity (\$/kWh)', _electricityCost, 0.01, 0.50, (v) => setState(() => _electricityCost = v), divisions: 49),
          const SizedBox(height: 20),
          Text('Duration', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Row(
            children: [7, 30, 90, 365].map((d) => Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _days = d),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _days == d ? AppColors.primaryNeon.withValues(alpha: 0.2) : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _days == d ? AppColors.primaryNeon : AppColors.glassBorder),
                  ),
                  child: Center(child: Text('$d d', style: TextStyle(
                    color: _days == d ? AppColors.primaryNeon : AppColors.textSecondary,
                    fontWeight: _days == d ? FontWeight.bold : FontWeight.normal,
                  ))),
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderInput(String label, double value, double min, double max, Function(double) onChanged, {int divisions = 199}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: AppColors.textSecondary)),
            Text(value.toStringAsFixed(value < 1 ? 2 : 0), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.primaryNeon,
            inactiveTrackColor: AppColors.surfaceVariant,
            thumbColor: AppColors.primaryNeon,
            overlayColor: AppColors.primaryNeon.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildResultsPanel() {
    final profitColor = _dailyProfit >= 0 ? AppColors.success : AppColors.error;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [profitColor.withValues(alpha: 0.15), profitColor.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: profitColor.withValues(alpha: 0.5), width: 2),
        boxShadow: [BoxShadow(color: profitColor.withValues(alpha: 0.2), blurRadius: 20)],
      ),
      child: Column(
        children: [
          Text('Estimated Results', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildResultItem('Daily Revenue', '\$$_dailyRevenue.toStringAsFixed(2)', AppColors.success)),
              Expanded(child: _buildResultItem('Daily Cost', '\$$_dailyCost.toStringAsFixed(2)', AppColors.warning)),
              Expanded(child: _buildResultItem('Daily Profit', '\$$_dailyProfit.toStringAsFixed(2)', profitColor)),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Monthly Profit', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('\$${(_dailyProfit * _days).toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: profitColor)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ROI', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${_monthlyROI.toStringAsFixed(1)}%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: profitColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
      ],
    );
  }

  Widget _buildHardwareSuggestions() {
    final hardware = [
      {'name': 'Antminer S19 Pro', 'hashrate': '110 TH/s', 'price': '\$2,499'},
      {'name': 'Antminer S9K', 'hashrate': '14 TH/s', 'price': '\$549'},
      {'name': 'WhatsMiner M30S+', 'hashrate': '100 TH/s', 'price': '\$1,899'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recommended Hardware', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...hardware.map((hw) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.primaryNeon, AppColors.secondaryNeon]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.memory, color: AppColors.background),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hw['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(hw['hashrate'] as String, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              Text(hw['price'] as String, style: TextStyle(color: AppColors.primaryNeon, fontWeight: FontWeight.bold)),
            ],
          ),
        )),
      ],
    );
  }

  @override
  void dispose() {
    _hashrateController.dispose();
    _powerController.dispose();
    _electricityController.dispose();
    super.dispose();
  }
}