import 'dart:convert';

import 'package:lkmobileapp/entity/contract.dart';
import 'package:lkmobileapp/entity/contract_status.dart';
import 'package:lkmobileapp/lk_preferences.dart';
import 'package:lkmobileapp/output/rest_client.dart';

class ContractStatusClient {
  Future<ContractStatusEntity> suspendContract(Contract contract, int status) async {
    if (status == 0 || status == 4) {
      var response = await RestClient
          .getInstance()
          .get(contract.title, Uri.parse("${LkPreferences.hostProxy}/request/setContractStatus?status=$status"));
      return ContractStatusEntity.fromJson(response);

    } else {
      throw Exception("Введено не правильное значение статуса!");
    }
  }

  Future<int> getStatus(Contract contract) async {
    var response = await RestClient
        .getInstance()
        .getClient(contract.title)
        .get(Uri.parse("${LkPreferences.hostProxy}/request/getContract"));
    Map<String, dynamic> map = jsonDecode(response.body);
    return map["status"];
  }
}
