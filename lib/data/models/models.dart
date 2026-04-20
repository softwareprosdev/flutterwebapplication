class Holding {
  final String coinId;
  final double amount;
  final double purchasePrice;
  final DateTime purchaseDate;

  Holding({
    required this.coinId,
    required this.amount,
    required this.purchasePrice,
    DateTime? purchaseDate,
  }) : purchaseDate = purchaseDate ?? DateTime.now();
}

class PriceData {
  final String coinId;
  final double price;
  final double change24h;
  final double volume;

  PriceData({
    required this.coinId,
    required this.price,
    required this.change24h,
    required this.volume,
  });
}