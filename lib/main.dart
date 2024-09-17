import 'package:flutter/material.dart';
import 'package:flutter_application/features/auth/blocs/auth_bloc.dart';
import 'package:flutter_application/features/auth/data/services/auth_service.dart';
import 'package:flutter_application/features/auth/ui/login_screen.dart';
import 'package:flutter_application/features/auth/ui/register_screen.dart';
import 'package:flutter_application/features/home/blocs/general_bloc.dart';
import 'package:flutter_application/features/home/ui/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  final Database db = await authService.openDatabaseFunc();

  runApp(MyApp(authService: authService, db: db));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final Database db;

  const MyApp({super.key, required this.authService, required this.db});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authService: authService),
        ),
        BlocProvider(
          create: (context) => GeneralBloc(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/loginScreen',
        routes: {
          '/registerScreen': (context) => RegisterScreen(db: db),
          '/loginScreen': (context) => LoginScreen(
                authService: authService,
              ),
          '/homeScreen': (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, String>;
            return HomeScreen(username: args['username']!);
          },
        },
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => LoginScreen(authService: authService),
        ),
      ),
    );
  }
}
