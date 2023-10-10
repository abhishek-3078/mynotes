import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

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
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Container(
        height: 400,
        margin: const EdgeInsets.all(12.0),
        padding: const EdgeInsets.only(left: 10,right: 10,top:30),
        decoration:  BoxDecoration(
          color: Colors.white,
          border:  Border.all(
                      color: const Color.fromARGB(102, 69, 76, 74),
                      width: 1.0,
                      style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow:const [
           BoxShadow(
                      color: Color.fromARGB(255, 73, 77, 73),
                      offset:  Offset(
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
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(fontSize: 18.0),
              decoration:
                  const InputDecoration(hintText: 'Enter your Email here',
                  
                  ),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration:
                  const InputDecoration(hintText: 'Enter your password hre'),
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
         await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email,
                           password: password,
                           );
          if (!context.mounted) return;
           Navigator.of(context).pushNamedAndRemoveUntil('/notes/', (route) => false,);
                } on FirebaseAuthException catch (e) {
                  if (e.code == "INVALID_LOGIN_CREDENTIALS") {
                    devtools.log("wrong happended");
                  } else {
                    devtools.log(e.code);
                  }
                }
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/register', (route) => false);
              },
              child: const Text('Not Registered yet? Register here!'),
            )
          ],
        ),
      ),
    );
  }
}
