import 'dart:convert';

import 'package:lkmobileapp/entity/contract.dart';
import 'package:lkmobileapp/entity/contract_tariff.dart';
import 'package:lkmobileapp/lk_preferences.dart';
import 'package:lkmobileapp/output/rest_client.dart';

class TariffClient {
  Future<List<ContractTariff>> getTariff(Contract contract) async {
    var response = await RestClient
        .getInstance()
        .getClient(contract.title)
        .get(Uri.parse("${LkPreferences.hostProxy}/request/getContractTariff"));
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<ContractTariff> tariff = data
        .map((tagJson) => ContractTariff.fromJson(tagJson))
        .toList();
    return tariff;
  }
}