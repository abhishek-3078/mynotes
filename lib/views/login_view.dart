import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';
import 'package:mynotes/utilities/dialogs/loading_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  // CloseDialog? _closeDialogHandle;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is InvalidLoginCredentialsAuthException) {
            await showErrorDialog(context, "Invalid Credentials");
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication Error');
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 202, 228, 234),
        appBar: AppBar(title: const Text("Login")),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: 400,
            margin: const EdgeInsets.only(top: 60),
            padding: const EdgeInsets.only(left: 13, right: 13, top: 13.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: const Color.fromARGB(102, 69, 76, 74),
                  width: 1.0,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 73, 77, 73),
                  offset: Offset(
                    5.0,
                    5.0,
                  ),
                  blurRadius: 10.0,
                  spreadRadius: 7.0,
                ), //BoxShadow
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0.0, 0.0),
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ),
              ],
            ),
            child: Column(

              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 8.0),
                  child: TextField(
                    
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      hintText: 'Enter your email here',
                
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color:
                              Colors.grey, // Customize the default border color
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  style: const TextStyle(fontSize:18.0),
                  decoration:  InputDecoration(
                      hintText: 'Enter your password here',
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color:
                            Colors.grey, // Customize the default border color
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    context.read<AuthBloc>().add(AuthEventLogIn(
                          email,
                          password,
                        ));
                  },
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () async {
                    context
                        .read<AuthBloc>()
                        .add(const AuthEventForgotPassword());
                  },
                  child: const Text('I forgot my password'),
                ),
                TextButton(
                  onPressed: () {
                    context
                        .read<AuthBloc>()
                        .add(const AuthEventShouldRegister());
                  },
                  child: const Text('Not Registered yet? Register here!'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
