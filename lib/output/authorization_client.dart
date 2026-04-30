import 'dart:convert';
import 'dart:developer';

import 'package:lkmobileapp/entity/change_password.dart';
import 'package:lkmobileapp/entity/contract_details.dart';
import 'package:lkmobileapp/lk_preferences.dart';
import 'package:lkmobileapp/notification_service.dart';
import 'package:lkmobileapp/output/firebase_token_client.dart';
import 'package:lkmobileapp/output/rest_client.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:http/http.dart' as http;

class Authorization {
  final NotificationService notificationService;

  FirebaseTokenClient firebaseTokenClient;

  Authorization(
      {required this.notificationService, required this.firebaseTokenClient});

  Future<ContractDetails> login(String login, String password) async {
    // todo : Необходимо добавить что бы при авторизации клиента на сервере клиент
    // передавал на сервер токен. Самый правильный вариант будет
    log('Начало процесса авторизации $login');
    var client = RestClient.getInstance().getNewClient(login, password);
    var response = await client
        .get(Uri.parse("${LkPreferences.hostProxy}/request/getContractData"));
    Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    if (data.containsKey("error")) {
      throw Exception(data["error"] + " status = " + data["status"].toString());
    }
    ContractDetails contractDetail = ContractDetails.fromJson(data);
    contractDetail.password = password;
    contractDetail.contract.password = password;
    if (UniversalPlatform.isAndroid ||
        UniversalPlatform.isIOS ||
        UniversalPlatform.isWeb) {
      String token = await notificationService.getDeviceToken();
      await firebaseTokenClient.setToken(contractDetail, token);
    }
    return contractDetail;
  }

  Future<dynamic> changePassword(ChangePasswordRequest request) async {
    var response = await RestClient.getInstance().post(
        request.login,
        Uri.parse("${LkPreferences.hostProxy}/request/changePassword"),
        request.toJson()
    );
    return response;
  }
}
