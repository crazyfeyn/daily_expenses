import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_application/features/auth/blocs/auth_bloc.dart';
import 'package:flutter_application/features/auth/blocs/auth_events.dart';
import 'package:flutter_application/features/auth/blocs/auth_states.dart';

class RegisterScreen extends StatefulWidget {
  final Database db;
  const RegisterScreen({super.key, required this.db});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordAgainController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    passwordAgainController.dispose();
    super.dispose();
  }

  Future<void> _onTapRegister() async {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        AuthRegisterEvent(
          widget.db,
          usernameController.text,
          passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.47,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    // image: DecorationImage(
                    //   image: AssetImage('assets/images/onboarding_first.png'),
                    //   fit: BoxFit.fill,
                    //   alignment: Alignment.topCenter,
                    // ),
                    ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello rookies,",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Text(
                      "Enter your information below or login with another account",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 35),
                  ],
                ),
              ),
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthAuthenticatedState) {
                    Navigator.pushReplacementNamed(context, '/userInfoScreen',
                        arguments: {
                          'username': usernameController.text,
                          'password': passwordController.text,
                        });
                  } else if (state is AuthErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextFormField(
                        controller: passwordAgainController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: 350,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            overlayColor: Colors.black,
                            fixedSize: const Size(145, 50),
                            backgroundColor: Colors.yellow,
                          ),
                          onPressed: _onTapRegister,
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
