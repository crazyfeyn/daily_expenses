import 'package:flutter_application/features/home/data/models/expanse_model.dart';
import 'package:flutter_application/features/home/data/models/general_model.dart';

abstract class GeneralEvent {}

class LoadGeneralEvent extends GeneralEvent {
  final String username;
  LoadGeneralEvent(this.username);
}

class AddGeneralEvent extends GeneralEvent {
  final GeneralModel general;
  AddGeneralEvent(this.general);
}

class UpdateGeneralEvent extends GeneralEvent {
  final GeneralModel general;
  UpdateGeneralEvent(this.general);
}

class AddExpenseEvent extends GeneralEvent {
  final ExpanseModel expense;
  final String username;

  AddExpenseEvent({required this.expense, required this.username});
}

class DeleteGeneralEvent extends GeneralEvent {
  final String username;
  DeleteGeneralEvent(this.username);
}
