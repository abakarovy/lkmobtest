class ConfigPreferences {
  Map<String, dynamic> map;

  ConfigPreferences({required this.map});

  factory ConfigPreferences.fromJson(Map<String, dynamic> json) {
    return ConfigPreferences(map: json['map']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['map'] = map;
    return data;
  }
}