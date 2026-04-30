class ChangePasswordRequest {

  final String login;
  final String oldPwd;
  final String newPwd;

  ChangePasswordRequest({required this.login, required this.oldPwd, required this.newPwd});

  ChangePasswordRequest.fromJson(Map<String, dynamic> json)
      : login = json['login'],
        newPwd = json['newPwd'],
        oldPwd = json['oldPwd'];

  Map<String, dynamic> toJson() => {
    'login': login,
    'newPwd': newPwd,
    'oldPwd': oldPwd,
  };
}
