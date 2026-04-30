import 'dart:developer';


import 'package:intl/intl.dart'; // Для работы с датами
// Для преобразования JSON

class Payment {
  int id;
  int contractId;
  int typeId;
  DateTime date;
  double sum;
  int userId;
  String comment;
  DateTime? timeChange;

  Payment({
    required this.id,
    required this.contractId,
    required this.typeId,
    required this.date,
    required this.sum,
    required this.userId,
    required this.comment,
    required this.timeChange,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      contractId: json['contractId'],
      typeId: json['typeId'],
      date: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").parse(json['date']),
      sum: json['sum'].toDouble(),
      userId: json['userId'],
      comment: json['comment'],
      timeChange: getDate(json['timeChange']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contractId': contractId,
      'typeId': typeId,
      'date': DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").format(date),
      'sum': sum,
      'userId': userId,
      'comment': comment,
      'timeChange': DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").format(timeChange!),
    };
  }

  // DateTime getDate(json) {
  //   (json.containsKey('timeChange')) ? DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").parse(json['timeChange']) : DateTime.now()
  // }
}

DateTime? getDate(dynamic data) {
  if (data == null) return null;
    try{
      return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").parse(data);
    }on Exception catch (e){
      log(e.toString());
      return null;
    }
}
