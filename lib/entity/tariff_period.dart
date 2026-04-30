

class TariffPeriod {
  DateTime dateFrom;
  String localDateFrom;
  DateTime? dateTo;
  String? localDateTo;
  DateTime dateFromCalendar;
  int yearFrom;
  int monthFrom;
  DateTime? dateToCalendar;

  TariffPeriod({
    required this.dateFrom,
    required this.localDateFrom,
    required this.dateTo,
    required this.localDateTo,
    required this.dateFromCalendar,
    required this.yearFrom,
    required this.monthFrom,
    required this.dateToCalendar,
  });

  factory TariffPeriod.fromJson(Map<String, dynamic> json) {
    return TariffPeriod(
      dateFrom: DateTime.parse(json['dateFrom']),
      localDateFrom: json['localDateFrom'],
      dateTo: json['dateTo'] != null ? DateTime.parse(json['dateTo']) : null,
      localDateTo: json['localDateTo'],
      dateFromCalendar: DateTime.parse(json['dateFromCalendar']),
      yearFrom: json['yearFrom'],
      monthFrom: json['monthFrom'],
      dateToCalendar: json['dateToCalendar'] != null ? DateTime.parse(json['dateToCalendar']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateFrom': dateFrom.toIso8601String(),
      'localDateFrom': localDateFrom,
      'dateTo': dateTo?.toIso8601String(),
      'localDateTo': localDateTo,
      'dateFromCalendar': dateFromCalendar.toIso8601String(),
      'yearFrom': yearFrom,
      'monthFrom': monthFrom,
      'dateToCalendar': dateToCalendar?.toIso8601String(),
    };
  }

}