import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/models.dart';
import '../../data/services/portfolio_service.dart';

// Events
abstract class PortfolioEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPortfolio extends PortfolioEvent {}

class AddHolding extends PortfolioEvent {
  final String coinId;
  final double amount;
  final double purchasePrice;
  
  AddHolding({required this.coinId, required this.amount, required this.purchasePrice});
  @override
  List<Object?> get props => [coinId, amount, purchasePrice];
}

class UpdateHolding extends PortfolioEvent {
  final String coinId;
  final double amount;
  
  UpdateHolding({required this.coinId, required this.amount});
  @override
  List<Object?> get props => [coinId, amount];
}

class RemoveHolding extends PortfolioEvent {
  final String coinId;
  
  RemoveHolding({required this.coinId});
  @override
  List<Object?> get props => [coinId];
}

class RefreshPrices extends PortfolioEvent {}

// States
abstract class PortfolioState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PortfolioInitial extends PortfolioState {}

class PortfolioLoading extends PortfolioState {}

class PortfolioLoaded extends PortfolioState {
  final List<Holding> holdings;
  final double totalValue;
  final double totalProfitLoss;
  final double totalProfitLossPercent;
  final Map<String, double> currentPrices;
  
  PortfolioLoaded({
    required this.holdings,
    required this.totalValue,
    required this.totalProfitLoss,
    required this.totalProfitLossPercent,
    required this.currentPrices,
  });
  
  @override
  List<Object?> get props => [holdings, totalValue, totalProfitLoss, totalProfitLossPercent, currentPrices];
}

class PortfolioError extends PortfolioState {
  final String message;
  PortfolioError({required this.message});
  @override
  List<Object?> get props => [message];
}

// BLoC
class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final PortfolioService _portfolioService;
  
  PortfolioBloc({PortfolioService? service})
      : _portfolioService = service ?? PortfolioService(),
        super(PortfolioInitial()) {
    on<LoadPortfolio>(_onLoadPortfolio);
    on<AddHolding>(_onAddHolding);
    on<UpdateHolding>(_onUpdateHolding);
    on<RemoveHolding>(_onRemoveHolding);
    on<RefreshPrices>(_onRefreshPrices);
  }

  Future<void> _onLoadPortfolio(LoadPortfolio event, Emitter<PortfolioState> emit) async {
    emit(PortfolioLoading());
    try {
      final holdings = await _portfolioService.getHoldings();
      final prices = await _portfolioService.fetchPrices();
      
      final loaded = await _calculatePortfolio(holdings, prices);
      emit(loaded);
    } catch (e) {
      emit(PortfolioError(message: e.toString()));
    }
  }

  Future<void> _onAddHolding(AddHolding event, Emitter<PortfolioState> emit) async {
    try {
      await _portfolioService.addHolding(event.coinId, event.amount, event.purchasePrice);
      add(LoadPortfolio());
    } catch (e) {
      emit(PortfolioError(message: e.toString()));
    }
  }

  Future<void> _onUpdateHolding(UpdateHolding event, Emitter<PortfolioState> emit) async {
    try {
      await _portfolioService.updateHolding(event.coinId, event.amount);
      add(LoadPortfolio());
    } catch (e) {
      emit(PortfolioError(message: e.toString()));
    }
  }

  Future<void> _onRemoveHolding(RemoveHolding event, Emitter<PortfolioState> emit) async {
    try {
      await _portfolioService.removeHolding(event.coinId);
      add(LoadPortfolio());
    } catch (e) {
      emit(PortfolioError(message: e.toString()));
    }
  }

  Future<void> _onRefreshPrices(RefreshPrices event, Emitter<PortfolioState> emit) async {
    if (state is PortfolioLoaded) {
      try {
        final prices = await _portfolioService.fetchPrices();
        final currentState = state as PortfolioLoaded;
        final loaded = await _calculatePortfolio(currentState.holdings, prices);
        emit(loaded);
      } catch (e) {
        // Keep current state on refresh failure
      }
    }
  }

  Future<PortfolioLoaded> _calculatePortfolio(List<Holding> holdings, Map<String, double> prices) async {
    double totalValue = 0;
    double totalCost = 0;

    for (final holding in holdings) {
      final currentPrice = prices[holding.coinId] ?? 0;
      totalValue += holding.amount * currentPrice;
      totalCost += holding.amount * holding.purchasePrice;
    }

    final profitLoss = totalValue - totalCost;
    final profitLossPercent = totalCost > 0 ? (profitLoss / totalCost) * 100 : 0;

    return PortfolioLoaded(
      holdings: holdings,
      totalValue: totalValue,
      totalProfitLoss: profitLoss,
      totalProfitLossPercent: profitLossPercent,
      currentPrices: prices,
    );
  }
}