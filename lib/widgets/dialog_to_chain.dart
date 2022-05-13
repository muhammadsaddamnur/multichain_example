import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichain_example/models/chain_id.dart';

import '../bloc/routers_bloc.dart';
import 'multi_dropdown.dart';

class DialogToChain extends StatelessWidget {
  const DialogToChain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoutersBloc, RoutersState>(
      builder: (context, state) {
        if (state is RoutersMain) {
          String id = '';
          Map<String, dynamic>? chain;
          if (state.selectedToChain != null) {
            id = state.selectedToChain!.keys.first;
            chain = ChainId.returnChain(id);
          }
          return MultiDropdown(
            title: '${state.selectedToChain == null ? '-' : chain!['name']}',
            image:
                '${state.selectedToChain == null ? null : state.selectedToChain!['logoUrl']}',
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        height: MediaQuery.of(context).size.height - 100,
                        child: DialogBodyChain()),
                  );
                },
              );
            },
          );
        }
        return MultiDropdown(
          title: '-',
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 100,
                    height: MediaQuery.of(context).size.height - 100,
                    child: DialogBodyChain(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class DialogBodyChain extends StatelessWidget {
  const DialogBodyChain({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff151A2F),
      appBar: AppBar(),
      body: BlocBuilder<RoutersBloc, RoutersState>(
        builder: (context, state) {
          if (state is RoutersMain) {
            return ListView.builder(
              itemCount: state.listToChain!.length,
              itemBuilder: (context, index) {
                // var bloc = state.listToChain![index];
                var id = state.listToChain![index].keys.first;
                Map<String, dynamic> chain = ChainId.returnChain(id);

                return ListTile(
                  leading: CircleAvatar(),
                  title: Text(
                    '${chain['name']}',
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    id +
                        '\n' +
                        state.listToChain![index].values.first['anyToken']
                            ['address'],
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () async {
                    context.read<RoutersBloc>().add(SelectedToChain(index));
                    // context
                    //     .read<RoutersBloc>()
                    //     .add(GetTokenList(bloc[index]['chainId']));
                    Navigator.pop(context);
                  },
                );
              },
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
