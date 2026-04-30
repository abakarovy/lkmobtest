class ContractBalance {
  int year;
  int month;
  double incomingSaldo;
  double accounts;
  double payments;
  double charges;
  int reserve;
  int timestamp;

  ContractBalance({
    required this.year,
    required this.month,
    required this.incomingSaldo,
    required this.accounts,
    required this.payments,
    required this.charges,
    required this.reserve,
    required this.timestamp,
  });

  factory ContractBalance.fromJson(Map<String, dynamic> json) {
    return ContractBalance(
      year: json['year'],
      month: json['month'],
      incomingSaldo: json['incomingSaldo'],
      accounts: json['accounts'],
      payments: json['payments'],
      charges: json['charges'],
      reserve: json['reserve'],
      timestamp: json['timestamp'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'month': month,
      'incomingSaldo': incomingSaldo,
      'accounts': accounts,
      'payments': payments,
      'charges': charges,
      'reserve': reserve,
      'timestamp': timestamp,
    };
  }

  double getMoney(){
    return payments + incomingSaldo - accounts;
  }

}