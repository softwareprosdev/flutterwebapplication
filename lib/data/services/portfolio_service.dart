import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'models/models.dart';
import '../../../core/network/ssl_pinning_interceptor.dart';

class PortfolioService {
  static const String _holdingsKey = 'portfolio_holdings';
  static const String _pricesKey = 'cached_prices';

  Future<List<Holding>> getHoldings() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_holdingsKey);
    if (data == null) return [];
    
    final list = jsonDecode(data) as List;
    return list.map((e) => Holding(
      coinId: e['coinId'],
      amount: (e['amount'] as num).toDouble(),
      purchasePrice: (e['purchasePrice'] as num).toDouble(),
      purchaseDate: DateTime.parse(e['purchaseDate']),
    )).toList();
  }

  Future<void> addHolding(String coinId, double amount, double purchasePrice) async {
    final holdings = await getHoldings();
    final index = holdings.indexWhere((h) => h.coinId == coinId);
    
    if (index >= 0) {
      final existing = holdings[index];
      final newAmount = existing.amount + amount;
      final avgPrice = (existing.amount * existing.purchasePrice + amount * purchasePrice) / newAmount;
      holdings[index] = Holding(coinId: coinId, amount: newAmount, purchasePrice: avgPrice);
    } else {
      holdings.add(Holding(coinId: coinId, amount: amount, purchasePrice: purchasePrice));
    }
    
    await _saveHoldings(holdings);
  }

  Future<void> updateHolding(String coinId, double amount) async {
    final holdings = await getHoldings();
    final index = holdings.indexWhere((h) => h.coinId == coinId);
    
    if (index >= 0) {
      if (amount > 0) {
        holdings[index] = Holding(coinId: coinId, amount: amount, purchasePrice: holdings[index].purchasePrice);
      } else {
        holdings.removeAt(index);
      }
      await _saveHoldings(holdings);
    }
  }

  Future<void> removeHolding(String coinId) async {
    final holdings = await getHoldings();
    holdings.removeWhere((h) => h.coinId == coinId);
    await _saveHoldings(holdings);
  }

  Future<void> _saveHoldings(List<Holding> holdings) async {
    final prefs = await SharedPreferences.getInstance();
    final data = holdings.map((h) => {
      'coinId': h.coinId,
      'amount': h.amount,
      'purchasePrice': h.purchasePrice,
      'purchaseDate': h.purchaseDate.toIso8601String(),
    }).toList();
    await prefs.setString(_holdingsKey, jsonEncode(data));
  }

  Future<Map<String, double>> fetchPrices() async {
    try {
      final dio = NetworkSecurityConfig.createSecureDio();
      final response = await dio.get('https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,solana,cardano,ripple,dogecoin,polkadot,litecoin&vs_currencies=usd&include_24hr_change=true');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final prices = <String, double>{};
        data.forEach((key, value) {
          if (value is Map && value.containsKey('usd')) {
            prices[key] = (value['usd'] as num).toDouble();
          }
        });
        
        // Cache prices
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_pricesKey, jsonEncode(prices));
        
        return prices;
      }
    } catch (e) {
      // Try cached prices
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_pricesKey);
      if (cached != null) {
        return Map<String, double>.from(jsonDecode(cached));
      }
    }
    return {'bitcoin': 42500, 'ethereum': 2280, 'solana': 98};
  }
}