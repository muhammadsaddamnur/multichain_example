import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichain_example/models/chain_id.dart';
import 'package:multichain_example/widgets/dialog_from_chain.dart';
import 'package:multichain_example/widgets/dialog_from_token.dart';
import 'package:multichain_example/widgets/multi_dropdown.dart';

import 'bloc/routers_bloc.dart';
import 'services/route_abi.dart';
import 'widgets/dialog_to_chain.dart';
import 'widgets/multi_textfield.dart';

class RouterMultichain extends StatefulWidget {
  const RouterMultichain({Key? key}) : super(key: key);

  @override
  State<RouterMultichain> createState() => _RouterMultichainState();
}

class _RouterMultichainState extends State<RouterMultichain> {
  TextEditingController textFrom = TextEditingController();
  TextEditingController textTo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff151A2F),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'From',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Balance : -',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MultiTextField(
                    controller: textFrom,
                    onChanged: (value) {
                      context.read<RoutersBloc>().add(
                          SetPrice(double.parse(value.isEmpty ? '0' : value)));
                    },
                  ),
                  Row(
                    children: [
                      DialogFromToken(),
                      DialogFromChain(),
                    ],
                  ),
                  BlocBuilder<RoutersBloc, RoutersState>(
                    builder: (context, state) {
                      if (state is RoutersMain) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            (state.fromLiquidity ?? '').toString(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ),
          Icon(
            Icons.arrow_downward_rounded,
            color: Colors.white.withOpacity(0.3),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'To',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Balance : -',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocBuilder<RoutersBloc, RoutersState>(
                      builder: (context, state) {
                        if (state is RoutersMain) {
                          return Text(
                            state.price.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          );
                        }
                        return SelectableText(
                          '0',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        );
                      },
                    ),
                  ),
                  // MultiTextField(
                  //   controller: textTo,
                  // ),
                  Row(
                    children: [
                      DialogFromToken(),
                      DialogToChain(),
                    ],
                  ),
                  BlocBuilder<RoutersBloc, RoutersState>(
                    builder: (context, state) {
                      if (state is RoutersMain) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            (state.toLiquidity ?? '').toString(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<RoutersBloc, RoutersState>(
            builder: (context, state) {
              if (state is RoutersMain) {
                if (state.selectedToChain != null &&
                    state.selectedFromToken != null) {
                  Map<String, dynamic> value =
                      state.selectedToChain!.values.first;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color: const Color(0xff2B314F),
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(
                              '- Crosschain Fee is ${value['SwapFeeRatePerMillion']}%, Minimum Crosschain Fee is ${value['MinimumSwapFee']} ${state.selectedFromToken!['symbol']}, Maximum Crosschain Fee is ${value['MaximumSwapFee']} ${state.selectedFromToken!['symbol']}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            SelectableText(
                              '- Minimum Crosschain Amount is ${value['MinimumSwap']} ${state.selectedFromToken!['symbol']}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            SelectableText(
                              '- Maximum Crosschain Amount is ${value['MaximumSwap']} ${state.selectedFromToken!['symbol']}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            SelectableText(
                              '- Estimated Time of Crosschain Arrival is 10-30 min',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            SelectableText(
                              '- Crosschain amount larger than ${value['BigValueThreshold']} ${state.selectedFromToken!['symbol']} could take up to 12 hours',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return SizedBox();
              }
              return SizedBox();
            },
          ),
          BlocBuilder<RoutersBloc, RoutersState>(
            builder: (context, state) {
              if (state is RoutersMain) {
                if (state.selectedToChain != null &&
                    state.selectedFromToken != null) {
                  Map<String, dynamic> value =
                      state.selectedToChain!.values.first;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color: const Color(0xff2B314F),
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(
                              'Decimal : ${value['anyToken']['decimals']}\n\n'
                              'anySwapOutUnderlying(\n${state.selectedFromChainsId!['anyToken']['address']},'
                              '\ntoAddress,'
                              '\n${BigInt.from(state.price * double.parse('1${List<String>.generate(value['anyToken']['decimals'], (counter) => "0").join()}')).toString()},'
                              '\n${state.selectedToChain!.keys.first}\n)',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SelectableText(
                              'anySwapOut(\n${state.selectedFromChainsId!['anyToken']['address']},'
                              '\ntoAddress,'
                              '\n${BigInt.from(state.price * double.parse('1${List<String>.generate(value['anyToken']['decimals'], (counter) => "0").join()}')).toString()},'
                              '\n${state.selectedToChain!.keys.first}\n)',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            // ElevatedButton(
                            //   onPressed: () async {
                            //     /// liquidity yg atas
                            //     await RouteAbi().getBalance(
                            //       ChainId.returnChain(state
                            //           .selectedFromChainsId!['chainId']
                            //           .toString())['rpc'][0],
                            //       state.selectedFromChainsId!['address'],
                            //       state.selectedFromChainsId!['anyToken']
                            //           ['address'],
                            //       value['anyToken']['decimals'],
                            //     );

                            //     /// liquidity yg bawah
                            //     await RouteAbi().getBalance(
                            //       ChainId.returnChain(state
                            //           .selectedToChain!.keys.first
                            //           .toString())['rpc'][0],
                            //       state
                            //           .selectedToChain!.values.first['address'],

                            //       /// destination
                            //       state.selectedToChain!.values
                            //           .first['anyToken']['address'],

                            //       /// destination
                            //       value['anyToken']['decimals'],
                            //     );
                            //   },
                            //   child: Text('check liquidity'),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return SizedBox();
              }
              return SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
