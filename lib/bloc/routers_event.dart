part of 'routers_bloc.dart';

@immutable
abstract class RoutersEvent {}

class SelectedFromChain extends RoutersEvent {
  final int index;

  SelectedFromChain(this.index);
}

class SelectedToChain extends RoutersEvent {
  final int index;

  SelectedToChain(this.index);
}

class SelectedFromToken extends RoutersEvent {
  final int index;

  SelectedFromToken(this.index);
}

class SetPrice extends RoutersEvent {
  final double price;

  SetPrice(this.price);
}

class GetTokenList extends RoutersEvent {
  final int chainId;

  GetTokenList(this.chainId);
}

class GetServerInfo extends RoutersEvent {
  final int chainId;
  final String version;

  GetServerInfo(this.chainId, this.version);
}
