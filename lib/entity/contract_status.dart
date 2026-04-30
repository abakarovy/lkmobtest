




class ContractStatusEntity {
  final int status;
  final String message;

  ContractStatusEntity({required this.status, required this.message});

  ContractStatusEntity.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        message = json['message'];

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
  };
}
