import 'package:intl/intl.dart';
import 'package:lkmobileapp/entity/tariff_period.dart';

class ContractTariff {
  int id;
  int contractId;
  int tariffPlanId;
  int tariffGroupId;
  int position;
  int entityMid;
  int entityId;
  int replacedFromContractTariffId;
  TariffPeriod period;
  String comment;
  DateTime? dateTo;
  DateTime dateFrom;

  ContractTariff({
    required this.id,
    required this.contractId,
    required this.tariffPlanId,
    required this.tariffGroupId,
    required this.position,
    required this.entityMid,
    required this.entityId,
    required this.replacedFromContractTariffId,
    required this.period,
    required this.comment,
    required this.dateTo,
    required this.dateFrom,
  });

  factory ContractTariff.fromJson(Map<String, dynamic> json) {
    return ContractTariff(
      id: json['id'],
      contractId: json['contractId'],
      tariffPlanId: json['tariffPlanId'],
      tariffGroupId: json['tariffGroupId'],
      position: json['position'],
      entityMid: json['entityMid'],
      entityId: json['entityId'],
      replacedFromContractTariffId: json['replacedFromContractTariffId'],
      period: TariffPeriod.fromJson(json['period']),
      comment: json['comment'],
      dateTo: json['dateTo'] != null ? DateTime.parse(json['dateTo']) : null,
      dateFrom: DateTime.parse(json['dateFrom']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contractId': contractId,
      'tariffPlanId': tariffPlanId,
      'tariffGroupId': tariffGroupId,
      'position': position,
      'entityMid': entityMid,
      'entityId': entityId,
      'replacedFromContractTariffId': replacedFromContractTariffId,
      'period': period.toJson(),
      'comment': comment,
      'dateTo': dateTo != null ? DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").format(dateTo!) : null,
      'dateFrom': DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").format(dateFrom),
    };
  }
}
