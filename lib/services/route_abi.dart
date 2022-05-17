import 'package:http/http.dart';
import 'package:multichain_example/models/multichain_abi.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/web3dart.dart';

class RouteAbi {
  // String rpcUrl = 'https://maticnode1.anyswap.exchange'; // polygon
  // String rpcUrl = 'https://cloudflare-eth.com'; // eth

  Future<DeployedContract> loadContract() async {
    String abi = MultichainAbi.abi;
    String contractAddress = "0xd69b31c3225728CC57ddaf9be532a4ee1620Be51";
    final contract = DeployedContract(ContractAbi.fromJson(abi, 'multichain'),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  Future getBalance(
    String rpcUrl,
    String address,
    String anyAddress,
    int decimals,
  ) async {
    print(rpcUrl);
    print(address);
    print(anyAddress);
    final ethClient = Web3Client(rpcUrl, Client());
    final erc20 =
        Erc20(address: EthereumAddress.fromHex(address), client: ethClient);

    final result = (await erc20.balanceOf(EthereumAddress.fromHex(anyAddress)));

    print(result.toInt() / 1000000);
    final dec = 1 *
        double.parse(
            '1${List<String>.generate(decimals, (counter) => "0").join()}');
    return (result.toDouble() / dec).toString();
  }
}
