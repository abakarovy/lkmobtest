
class Authority {
  String authority;

  Authority({
    required this.authority,
  });

  factory Authority.fromJson(Map<String, dynamic> json) {
    return Authority(
      authority: json['authority'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authority': authority,
    };
  }

}