import 'package:lkmobileapp/entity/tariff_plan.dart';

import 'authority.dart';
import 'contract.dart';
import 'contract_balance.dart';
import 'contract_tariff.dart';

class ContractDetails {
  Contract contract;
  String fullName;
  ContractBalance contractBalance;
  List<ContractTariff> contractTarifs;
  int id;
  bool enabled;
  String password;
  String username;
  bool credentialsNonExpired;
  bool accountNonExpired;
  List<Authority> authorities;
  bool accountNonLocked;
  List<TariffPlan> tariffPlans;

  ContractDetails({
    required this.contract,
    required this.fullName,
    required this.contractBalance,
    required this.contractTarifs,
    required this.id,
    required this.enabled,
    required this.password,
    required this.username,
    required this.credentialsNonExpired,
    required this.accountNonExpired,
    required this.authorities,
    required this.accountNonLocked,
    required this.tariffPlans,
  });

  factory ContractDetails.fromJson(Map<String, dynamic> json) {
    return ContractDetails(
      contract: Contract.fromJson(json['contract']),
      fullName: json['fullName'],
      contractBalance: ContractBalance.fromJson(json['contractBalance']),
      contractTarifs: List<ContractTariff>.from(json['contractTarifs'].map((x) => ContractTariff.fromJson(x))),
      tariffPlans: (json.containsKey('tariffPlans')) ? List<TariffPlan>.from(json['tariffPlans'].map((x) => TariffPlan.fromJson(x))) : List.empty(),
      //tariffPlans: List<TariffPlan>.from(json['tariffPlans'].map((x) => TariffPlan.fromJson(x))),
      id: json['id'],
      enabled: json['enabled'],
      password: json['password'],
      username: json['username'],
      credentialsNonExpired: json['credentialsNonExpired'],
      accountNonExpired: json['accountNonExpired'],
      authorities: List<Authority>.from(json['authorities'].map((x) => Authority.fromJson(x))),
      accountNonLocked: json['accountNonLocked'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'contract': contract.toJson(),
      'fullName': fullName,
      'contractBalance': contractBalance.toJson(),
      'contractTarifs': List<dynamic>.from(contractTarifs.map((x) => x.toJson())),
      'tariffPlans': List<dynamic>.from(tariffPlans.map((x) => x.toJson())),
      'id': id,
      'enabled': enabled,
      'password': password,
      'username': username,
      'credentialsNonExpired': credentialsNonExpired,
      'accountNonExpired': accountNonExpired,
      'authorities': List<dynamic>.from(authorities.map((x) => x.toJson())),
      'accountNonLocked': accountNonLocked,
    };
  }

}