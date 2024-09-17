class Income {
  final int id;
  final String username;
  final String name;
  final double amount;
  final String dateTime;

  Income({
    required this.id,
    required this.username,
    required this.name,
    required this.amount,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'amount': amount,
      'dateTime': dateTime,
    };
  }

  factory Income.fromMap(Map<String, dynamic> map) {
    return Income(
      id: map['id'],
      username: map['username'],
      name: map['name'],
      amount: map['amount'],
      dateTime: map['dateTime'],
    );
  }
}
