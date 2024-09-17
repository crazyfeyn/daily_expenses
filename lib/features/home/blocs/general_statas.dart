import 'package:flutter_application/features/home/data/models/general_model.dart';

abstract class GeneralState {}

class GeneralInitialState extends GeneralState {}

class GeneralLoadingState extends GeneralState {}

class GeneralLoadedState extends GeneralState {
  final GeneralModel general;
  GeneralLoadedState(this.general);
}

class GeneralErrorState extends GeneralState {
  final String message;
  GeneralErrorState(this.message);
}

class GeneralEmpty extends GeneralState {}
