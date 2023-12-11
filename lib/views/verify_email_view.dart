import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';


class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(title: const Text("Verify email"),backgroundColor: Colors.blueAccent,),
      body: Column(children: [
          const Text("We've sent you an email verification. Please open it to verify your account"),
          const Text("If you haven't received verification email yet, press the button below"),
          TextButton(onPressed: ()async{
            await AuthService.firebase().sendEmailVerification();
          }, child: const Text("Send Email Verification")),
          TextButton(
  onPressed: ()async {
    await AuthService.firebase().logOut();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
  },
  style: TextButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 91, 165, 225), // Change the background color to blue
    foregroundColor: const Color.fromARGB(255, 7, 3, 69), 
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
    textStyle: const TextStyle(fontSize: 17)
  ),
  child: const Text('Restart'),
)
        ]),
    );
    
  }
}