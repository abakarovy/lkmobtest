import 'dart:convert';

import 'package:lkmobileapp/entity/contract.dart';
import 'package:lkmobileapp/entity/contract_balance.dart';
import 'package:lkmobileapp/lk_preferences.dart';
import 'package:lkmobileapp/output/rest_client.dart';

class ContractBalanceClient {
  Future<ContractBalance> getBalance(Contract contract) async {
    var response = await RestClient
        .getInstance()
        .getClient(contract.title)
        .get(Uri.parse("${LkPreferences.hostProxy}/request/contractBalance"));
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    return ContractBalance.fromJson(data);
  }
}
