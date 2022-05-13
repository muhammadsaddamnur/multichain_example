import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/routers_bloc.dart';
import 'multi_dropdown.dart';

class DialogFromToken extends StatelessWidget {
  const DialogFromToken({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoutersBloc, RoutersState>(
      builder: (context, state) {
        if (state is RoutersMain) {
          return MultiDropdown(
            title:
                '${state.selectedFromToken == null ? '-' : state.selectedFromToken!['symbol']}',
            image:
                '${state.selectedFromToken == null ? null : state.selectedFromToken!['logoUrl']}',
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        height: MediaQuery.of(context).size.height - 100,
                        child: DialogBodyToken()),
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
                    child: DialogBodyToken(),
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

class DialogBodyToken extends StatelessWidget {
  const DialogBodyToken({
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
              itemCount: state.tokens!.length,
              itemBuilder: (context, index) {
                var bloc = state.tokens;

                return ListTile(
                  leading: bloc![index].values.toList()[0]['logoUrl'] == null ||
                          bloc[index].values.toList()[0]['logoUrl'] == "" ||
                          bloc[index]
                              .values
                              .toList()[0]['logoUrl']
                              .toString()
                              .contains('.svg')
                      ? CircleAvatar()
                      : CircleAvatar(
                          backgroundImage: NetworkImage(
                              '${bloc[index].values.toList()[0]['logoUrl']}'),
                        ),
                  title: Text(
                    '${bloc[index].values.toList()[0]['symbol']}',
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${bloc[index].values.toList()[0]['name']}',
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () async {
                    context.read<RoutersBloc>().add(SelectedFromToken(index));
                    context.read<RoutersBloc>().add(GetServerInfo(
                        state.selectedFromChainsId!['chainId'], 'all'));
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
