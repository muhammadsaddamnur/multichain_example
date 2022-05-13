import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/routers_bloc.dart';
import 'multi_dropdown.dart';

class DialogFromChain extends StatelessWidget {
  const DialogFromChain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoutersBloc, RoutersState>(
      builder: (context, state) {
        if (state is RoutersMain) {
          return MultiDropdown(
            title: '${state.selectedFromChainsId!['name']}',
            image: state.selectedFromChainsId == null
                ? ''
                : state.selectedFromChainsId!['image'],
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
          return ListView.builder(
            itemCount: context.read<RoutersBloc>().listFromChains.length,
            itemBuilder: (context, index) {
              var bloc = context.read<RoutersBloc>();
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage('${bloc.listFromChains[index]['image']}'),
                ),
                title: Text(
                  '${bloc.listFromChains[index]['name']}',
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${bloc.listFromChains[index]['name']}',
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () async {
                  context.read<RoutersBloc>().add(SelectedFromChain(index));
                  context
                      .read<RoutersBloc>()
                      .add(GetTokenList(bloc.listFromChains[index]['chainId']));
                  Navigator.pop(context);
                },
              );
            },
          );
        },
      ),
    );
  }
}
