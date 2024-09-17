import 'dart:convert';
import 'package:flutter_application/features/home/data/models/expanse_model.dart';
import 'package:flutter_application/features/home/data/models/income.dart';

class GeneralModel {
  final String username;
  final double totalSalary;
  final List<ExpanseModel> expanseList;
  final List<Income> incomeList;

  GeneralModel({
    required this.username,
    required this.totalSalary,
    required this.expanseList,
    required this.incomeList,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'totalSalary': totalSalary,
      'expanseList': jsonEncode(expanseList.map((e) => e.toMap()).toList()),
      'incomeList': jsonEncode(incomeList.map((i) => i.toMap()).toList()),
    };
  }

  factory GeneralModel.fromMap(Map<String, dynamic> map) {
    return GeneralModel(
      username: map['username'],
      totalSalary: map['totalSalary'],
      expanseList: (jsonDecode(map['expanseList']) as List<dynamic>)
          .map((item) => ExpanseModel.fromMap(item))
          .toList(),
      incomeList: (jsonDecode(map['incomeList']) as List<dynamic>)
          .map((item) => Income.fromMap(item))
          .toList(),
    );
  }
}
