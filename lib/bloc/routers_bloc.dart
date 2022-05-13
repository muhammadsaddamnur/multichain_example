import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'routers_event.dart';
part 'routers_state.dart';

class RoutersBloc extends Bloc<RoutersEvent, RoutersState> {
  double price = 0;

  Map<String, dynamic>? selectedFromChainsId;
  List<Map<String, dynamic>> listFromChains = [
    {
      'name': 'Ethereum',
      'chainId': 1,
      'image':
          'https://assets.coingecko.com/coins/images/279/large/ethereum.png'
    },
    {
      'name': 'Polygon',
      'chainId': 137,
      'image':
          'https://assets.coingecko.com/coins/images/4713/large/matic-token-icon.png'
    },
    {
      'name': 'BSC',
      'chainId': 56,
      'image':
          'https://chainlist.org/_next/image?url=https%3A%2F%2Fdefillama.com%2Fchain-icons%2Frsz_binance.jpg&w=32&q=75'
    },
    {
      'name': 'Avalanche',
      'chainId': 43114,
      'image':
          'https://chainlist.org/_next/image?url=https%3A%2F%2Fdefillama.com%2Fchain-icons%2Frsz_avalanche.jpg&w=32&q=75'
    },
    {
      'name': 'Velas',
      'chainId': 106,
      'image':
          'https://chainlist.org/_next/image?url=https%3A%2F%2Fdefillama.com%2Fchain-icons%2Frsz_velas.jpg&w=32&q=75'
    },
  ];
  List<Map<String, dynamic>> listTokens = [];
  Map<String, dynamic>? selectedFromToken;

  List<Map<String, dynamic>> listToChain = [];
  Map<String, dynamic>? selectedToChainsId;

  RoutersBloc()
      : super(
          RoutersInitial(),
        ) {
    on<SelectedFromChain>((event, emit) async {
      selectedFromChainsId = listFromChains[event.index];
      selectedFromToken = null;
      selectedToChainsId = null;
      listTokens = [];
      listToChain = [];
      price = 0;
      emit(RoutersMain(
        tokens: listTokens,
        selectedFromToken: selectedFromToken,
        selectedFromChainsId: selectedFromChainsId,
        selectedToChain: selectedToChainsId,
        listToChain: listToChain,
        price: price,
      ));
    });

    on<SelectedToChain>((event, emit) async {
      selectedToChainsId = listToChain[event.index];
      price = 0;
      emit(RoutersMain(
        tokens: listTokens,
        selectedFromToken: selectedFromToken,
        selectedFromChainsId: selectedFromChainsId,
        selectedToChain: selectedToChainsId,
        listToChain: listToChain,
        price: price,
      ));
    });

    on<SelectedFromToken>((event, emit) async {
      selectedFromToken = listTokens[event.index].values.toList().first;
      selectedToChainsId = null;
      listToChain = [];
      price = 0;
      emit(RoutersMain(
        tokens: listTokens,
        selectedFromToken: selectedFromToken,
        selectedFromChainsId: selectedFromChainsId,
        selectedToChain: selectedToChainsId,
        listToChain: listToChain,
        price: price,
      ));
    });

    on<SetPrice>((event, emit) async {
      price = event.price -
          double.parse(selectedToChainsId == null
              ? '0'
              : (event.price >=
                      double.parse(selectedToChainsId!
                          .values.first['MaximumSwap']
                          .toString())
                  ? selectedToChainsId!.values.first['MaximumSwapFee']
                  : event.price <
                          double.parse(selectedToChainsId!
                              .values.first['MinimumSwap']
                              .toString())
                      ? event.price.toString()
                      : selectedToChainsId!.values.first['MinimumSwapFee']));

      print(price);
      emit(RoutersMain(
        tokens: listTokens,
        selectedFromToken: selectedFromToken,
        selectedFromChainsId: selectedFromChainsId,
        selectedToChain: selectedToChainsId,
        listToChain: listToChain,
        price: price,
      ));
    });

    on<GetTokenList>((event, emit) async {
      try {
        print('loading');
        print(
            'https://bridgeapi.anyswap.exchange/merge/tokenlist/${event.chainId}');
        var response = await Dio().get(
            'https://bridgeapi.anyswap.exchange/merge/tokenlist/${event.chainId}');

        List<Map<String, dynamic>> listTokens1 = [];
        var result = await json.decode(response.toString());

        // await result.forEach((k, v) => listTokens1.add({k: v}));

        List tokenCoinbit = [
          'BTC',
          'ETH',
          'BNB',
          'MATIC',
          'SOL',
          'AVAX',
          'USDT',
          'USDC'
        ];
        await result.forEach((k, v) {
          if (tokenCoinbit.contains(v['symbol'])) {
            listTokens1.add({k: v});
          }
        });

        // log(listTokens1[0].values.toList().first.toString());
        listTokens = listTokens1;
        // log(listTokens[0].values.toList().first.toString());

        // log(listValue[0].values.toList()[0]['name'].toString());
        emit(RoutersMain(
          tokens: listTokens,
          selectedFromToken: selectedFromToken,
          selectedFromChainsId: selectedFromChainsId,
          selectedToChain: selectedToChainsId,
          listToChain: listToChain,
          price: price,
        ));
        print('done');
      } catch (e) {
        print(e);
      }
    });

    on<GetServerInfo>((event, emit) async {
      try {
        print('loading');
        print(
            'https://bridgeapi.anyswap.exchange/v3/serverinfoV3?chainId=${event.chainId}&version=${event.version}');
        var response = await Dio().get(
            'https://bridgeapi.anyswap.exchange/v3/serverinfoV3?chainId=${event.chainId}&version=${event.version}');

        List<Map<String, dynamic>> listTokens1 = [];
        List<Map<String, dynamic>> listChain1 = [];
        var result = await json.decode(response.toString());
        // log(response.toString());

        await result['STABLEV3'].forEach((k, v) {
          // log(v.toString());
          if (v['anyToken']['symbol']
              .toString()
              .contains(selectedFromToken!['symbol'])) {
            // log(v.toString());
            listTokens1.add(v);
          }
        });
        await result['UNDERLYINGV2'].forEach((k, v) {
          // log(v.toString());
          if (v['anyToken']['symbol']
              .toString()
              .contains(selectedFromToken!['symbol'])) {
            // log(v.toString());
            listTokens1.add(v);
          }
        });
        await result['NATIVE'].forEach((k, v) {
          // log(v.toString());
          if (v['anyToken']['symbol']
              .toString()
              .contains(selectedFromToken!['symbol'])) {
            // log(v.toString());
            listTokens1.add(v);
          }
        });

        await listTokens1.first['destChains'].forEach((k, v) {
          listChain1.add({k: v});
        });

        listToChain = listChain1;
        emit(RoutersMain(
          tokens: listTokens,
          selectedFromToken: selectedFromToken,
          selectedFromChainsId: selectedFromChainsId,
          selectedToChain: selectedToChainsId,
          listToChain: listToChain,
          price: price,
        ));
        // await result.forEach((k, v) {
        //   if (['USDT', 'USDC'].contains(selectedFromToken!['symbol'])) {
        //     listTokens1.add({k: v});
        //     log(listTokens1.toString());
        //   } else {
        //     listTokens1.add({k: v});
        //     log(listTokens1[1].toString());
        //   }
        // });

        // log(listTokens1[0].values.toList().first.toString());

        print('done');
      } catch (e) {
        print(e);
      }
    });
  }
}
