
import 'package:lkmobileapp/entity/contract_details.dart';
import 'package:lkmobileapp/lk_preferences.dart';
import 'package:lkmobileapp/output/rest_client.dart';

class FirebaseTokenClient{

  FirebaseTokenClient();

  Future<void> setToken(ContractDetails contractDetails,
      String token) async {
    await RestClient.getInstance().getWithoutResult(
        contractDetails.username, Uri.parse(
            "${LkPreferences.hostProxy}/request/setToken?"
                "newToken=$token"));
  }

  void setTokenForContracts(List<ContractDetails> contractDetailList,
      String token) async {
    for (var element in contractDetailList) {
      await setToken(element, token);
    }
  }

  Future<void> refreshToken(
      ContractDetails contractDetails,
      String oldToken,
      String newToken) async {
    await RestClient.getInstance().getWithoutResult(
        contractDetails.username,
        Uri.parse(
            "${LkPreferences.hostProxy}/request/setToken?"
                "oldToken=$oldToken&"
                "newToken=$newToken"));
  }

  Future<void> removeToken(ContractDetails  contractDetail, String firebaseToken) async {
    await RestClient.getInstance().getWithoutResult(
        contractDetail.username,
        Uri.parse(
            "${LkPreferences.hostProxy}/request/removeToken?"
                "token=$firebaseToken"));
  }

}
