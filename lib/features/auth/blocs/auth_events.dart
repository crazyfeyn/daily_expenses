import 'package:equatable/equatable.dart';
import 'package:sqflite/sqflite.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthRegisterEvent extends AuthEvent {
  final Database db;
  final String username;
  final String password;

  const AuthRegisterEvent(this.db, this.username, this.password);

  @override
  List<Object?> get props => [username, password];
}

class AuthLoginEvent extends AuthEvent {
  final Database db;
  final String username;
  final String password;

  const AuthLoginEvent(this.db, this.username, this.password);

  @override
  List<Object?> get props => [username, password];
}

class AuthLogoutEvent extends AuthEvent {}

class AuthCheckEvent extends AuthEvent {}
