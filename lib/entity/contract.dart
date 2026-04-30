
class Contract {
  int id;
  String title;
  int groups;
  String password;
  DateTime dateFrom;
  DateTime? dateTo;
  int balanceMode;
  int paramGroupId;
  int personType;
  String comment;
  bool hidden;
  int superCid;
  String dependSubList;
  int status;
  DateTime statusTimeChange;
  int titlePatternId;
  int balanceSubMode;
  int domainId;
  bool superContract;
  double balanceLimit;
  bool independSub;
  bool sub;
  bool dependSub;

  Contract({
    required this.id,
    required this.title,
    required this.groups,
    required this.password,
    required this.dateFrom,
    required this.dateTo,
    required this.balanceMode,
    required this.paramGroupId,
    required this.personType,
    required this.comment,
    required this.hidden,
    required this.superCid,
    required this.dependSubList,
    required this.status,
    required this.statusTimeChange,
    required this.titlePatternId,
    required this.balanceSubMode,
    required this.domainId,
    required this.superContract,
    required this.balanceLimit,
    required this.independSub,
    required this.sub,
    required this.dependSub,
  });



  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      id: json['id'],
      title: json['title'],
      groups: json['groups'],
      password: json['password'],
      dateFrom: DateTime.parse(json['dateFrom']),
      dateTo: json['dateTo'] != null ? DateTime.parse(json['dateTo']) : null,
      balanceMode: json['balanceMode'],
      paramGroupId: json['paramGroupId'],
      personType: json['personType'],
      comment: json['comment'],
      hidden: json['hidden'],
      superCid: json['superCid'],
      dependSubList: json['dependSubList'],
      status: json['status'],
      statusTimeChange: DateTime.parse(json['statusTimeChange']),
      titlePatternId: json['titlePatternId'],
      balanceSubMode: json['balanceSubMode'],
      domainId: json['domainId'],
      superContract: json['super'],
      balanceLimit: json['balanceLimit'],
      independSub: json['independSub'],
      sub: json['sub'],
      dependSub: json['dependSub'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'groups': groups,
      'password': password,
      'dateFrom': dateFrom.toIso8601String(),
      'dateTo': dateTo?.toIso8601String(),
      'balanceMode': balanceMode,
      'paramGroupId': paramGroupId,
      'personType': personType,
      'comment': comment,
      'hidden': hidden,
      'superCid': superCid,
      'dependSubList': dependSubList,
      'status': status,
      'statusTimeChange': statusTimeChange.toIso8601String(),
      'titlePatternId': titlePatternId,
      'balanceSubMode': balanceSubMode,
      'domainId': domainId,
      'super': superContract,
      'balanceLimit': balanceLimit,
      'independSub': independSub,
      'sub': sub,
      'dependSub': dependSub,
    };
  }
}