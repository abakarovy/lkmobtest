import 'dart:convert';

import 'package:lkmobileapp/entity/contract_details.dart';
import 'package:lkmobileapp/models/c2bmembers_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LkPreferences {
  // production server
  //static const String host = "https://192.162.212.1:8443/bgbilling/jsonWebApi";
  //static const String hostProxy = "http://192.162.212.49:18079";

  // clon dev server
//  static const String host = "http://10.0.0.222:8080/bgbilling/jsonWebApi";
  // static const String hostProxy = "http://localhost:8080";
  // static const String hostName = "lkproxy.fly-tech.ru";
  //static const String hostName = "localhost";
  static const String hostProxy = "https://lkproxy.fly-tech.ru";
  static const String sbpQrPaymentServiceUrl = "https://sber-sbp-qr.fly-tech.ru";

  late SharedPreferences _prefs;

  //String? firebaseToken;
  //FirebaseTokenClient firebaseTokenClient;

  LkPreferences();

  late List<ContractDetails> _contractDetails;
  bool isInit = false;
  List<AddContractListener> addContractListeners = List.empty(growable: true);
  List<RemoveContractListener> removeContractListeners = List.empty(growable: true);

  static List<C2bmemberModel> installedBanks = [];

  String? getSavedToken(){
    return _prefs.getString("firebaseToken");
  }

  init() async {
    if (!isInit) {
      _prefs = await SharedPreferences.getInstance();
      int? contractCount = _prefs.getInt("contract_count");
      if (contractCount == null || contractCount == 0) {
        _contractDetails = List.empty(growable: true);
      } else {
        try {
          _contractDetails = List.generate(contractCount, (index)  {
            String? jsonData = _prefs.getString("contract.$index");
            if (jsonData != null) {
              ContractDetails contractDetails =
                  ContractDetails.fromJson(jsonDecode(jsonData));
              return contractDetails;
            } else {
              throw Exception(
                  'Контракт с id $index не найден в SharedPreferences');
            }
          }, growable: true);
        } on Exception {
          _contractDetails = List.empty(growable: true);
        }
      }
      isInit = true;
    }
  }

  int addContract(ContractDetails contractDetails) {
    int index = _contractDetails.length;
    _contractDetails.add(contractDetails);
    _prefs.setString("contract.$index", jsonEncode(contractDetails.toJson()));
    _prefs.setInt("contract_count", _contractDetails.length);
    return _contractDetails.length-1;
  }

//  Future<void> removeContract(Contract contract) async {
//    _prefs.setInt("contract_count", _contractDetails.length);
//  }

  List<ContractDetails> getContractDetails() {
    return _contractDetails;
  }

  void changeContractPassword(index, newPwd) {
    _contractDetails[index].password = newPwd;
  }

  List<String> getContractTitleList() {
    List<String> contactsTitles = List.empty(growable: true);
    for (int i = 0; i < _contractDetails.length; i++) {
      contactsTitles.add(_contractDetails[i].contract.title);
    }
    return contactsTitles;
  }

  resetPrefs() {
    _prefs.clear();
    _contractDetails.clear();
  }


  updateContract(ContractDetails contractDetail, int i) {
    _contractDetails[i] = contractDetail;
    _prefs.setString("contract.$i", jsonEncode(contractDetail.toJson()));
  }

  void removeContract(int i) {
    _contractDetails.removeAt(i);
    _prefs.remove("contract.$i");
  }

  void setToken(String token) {
    _prefs.setString("firebaseToken", token);
  }

  /*void addAddContractListener(AddContractListener addContractListener){
    addContractListeners.add(addContractListener);
  }*/
}

abstract class AddContractListener {
  action(ContractDetails contractDetails);
}

abstract class RemoveContractListener {
  action(ContractDetails contractDetails);
}
