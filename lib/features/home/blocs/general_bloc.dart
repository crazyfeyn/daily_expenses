import 'package:flutter_application/features/home/blocs/general_events.dart';
import 'package:flutter_application/features/home/blocs/general_statas.dart';
import 'package:flutter_application/features/home/data/models/expanse_model.dart';
import 'package:flutter_application/features/home/data/models/general_model.dart';
import 'package:flutter_application/features/home/data/models/income.dart';
import 'package:flutter_application/features/home/data/services/database_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GeneralBloc extends Bloc<GeneralEvent, GeneralState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  GeneralBloc() : super(GeneralInitialState()) {
    on<LoadGeneralEvent>(_onLoadGeneral);
    on<AddGeneralEvent>(_onAddGeneral);
    on<UpdateGeneralEvent>(_onUpdateGeneral);
    on<DeleteGeneralEvent>(_onDeleteGeneral);
    on<AddExpenseEvent>(_onAddExpense);
  }

  Future<void> _onLoadGeneral(
      LoadGeneralEvent event, Emitter<GeneralState> emit) async {
    emit(GeneralLoadingState());
    try {
      final general = await _databaseHelper.getGeneral(event.username);
      if (general != null) {
        emit(GeneralLoadedState(general));
      } else {
        List<ExpanseModel> lst1 = [];
        List<Income> lst2 = [];
        final newGeneral = GeneralModel(
          username: event.username,
          totalSalary: 0.0,
          expanseList: lst1,
          incomeList: lst2,
        );
        await _databaseHelper.insertGeneral(newGeneral);
        emit(GeneralLoadedState(newGeneral));
      }
    } catch (e) {
      emit(GeneralErrorState(e.toString()));
    }
  }

  Future<void> _onAddGeneral(
      AddGeneralEvent event, Emitter<GeneralState> emit) async {
    emit(GeneralLoadingState());
    try {
      await _databaseHelper.insertGeneral(event.general);
      emit(GeneralLoadedState(event.general));
    } catch (e) {
      emit(GeneralErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateGeneral(
      UpdateGeneralEvent event, Emitter<GeneralState> emit) async {
    emit(GeneralLoadingState());
    try {
      await _databaseHelper.updateGeneral(event.general);
      emit(GeneralLoadedState(event.general));
    } catch (e) {
      emit(GeneralErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteGeneral(
      DeleteGeneralEvent event, Emitter<GeneralState> emit) async {
    emit(GeneralLoadingState());
    try {
      await _databaseHelper.deleteGeneral(event.username);
      emit(GeneralEmpty());
    } catch (e) {
      emit(GeneralErrorState(e.toString()));
    }
  }

  Future<void> _onAddExpense(
      AddExpenseEvent event, Emitter<GeneralState> emit) async {
    emit(GeneralLoadingState());
    try {
      await _databaseHelper.insertExpense(event.expense);
      final general = await _databaseHelper.getGeneral(event.username);
      if (general != null) {
        emit(GeneralLoadedState(general));
      } else {
        emit(GeneralErrorState("Failed to reload data after adding expense"));
      }
    } catch (e) {
      emit(GeneralErrorState(e.toString()));
    }
  }
}
