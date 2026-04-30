import 'config_preferences.dart';

class TariffPlan {
  int id;
  String title;
  bool used;
  bool useTitleInWeb;
  int filterGroups;
  int filterFace;
  String filterMask;
  String titleWeb;
  String config;
  dynamic comment;
  ConfigPreferences configPreferences;

  TariffPlan({
    required this.id,
    required this.title,
    required this.used,
    required this.useTitleInWeb,
    required this.filterGroups,
    required this.filterFace,
    required this.filterMask,
    required this.titleWeb,
    required this.config,
    required this.comment,
    required this.configPreferences,
  });

  factory TariffPlan.fromJson(Map<String, dynamic> json) {
    return TariffPlan(
    id: json['id'],
    title: json['title'],
    used: json['used'],
    useTitleInWeb: json['useTitleInWeb'],
    filterGroups: json['filterGroups'],
    filterFace: json['filterFace'],
    filterMask: json['filterMask'],
    titleWeb: json['titleWeb'],
    config: json['config'],
    comment: json['comment'],
    configPreferences: ((json['configPreferences'] != null)
        ? ConfigPreferences.fromJson(json['configPreferences'])
        : null)!
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['used'] = used;
    data['useTitleInWeb'] = useTitleInWeb;
    data['filterGroups'] = filterGroups;
    data['filterFace'] = filterFace;
    data['filterMask'] = filterMask;
    data['titleWeb'] = titleWeb;
    data['config'] = config;
    data['comment'] = comment;
    data['configPreferences'] = configPreferences.toJson();
      return data;
  }
}
