part of 'routers_bloc.dart';

@immutable
abstract class RoutersState {}

class RoutersInitial extends RoutersState {}

class RoutersMain extends RoutersState {
  final Map<String, dynamic>? selectedFromChainsId;
  final Map<String, dynamic>? selectedFromToken;
  final List<Map<String, dynamic>>? tokens;
  final Map<String, dynamic>? selectedToChain;
  final List<Map<String, dynamic>>? listToChain;
  final double price;
  final String? fromLiquidity;
  final String? toLiquidity;

  RoutersMain({
    this.selectedFromChainsId,
    this.tokens,
    this.selectedFromToken,
    this.selectedToChain,
    this.listToChain,
    required this.price,
    required this.fromLiquidity,
    required this.toLiquidity,
  });
}
