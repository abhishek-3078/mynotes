import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;


void main() {
 
  WidgetsFlutterBinding.ensureInitialized(); 
  devtools.log("jgjhbhj");
  runApp(MaterialApp(
      title: 'Flutter Demo',

      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        loginRoute:(context)=>const LoginView(),
        registerRoute:(context)=>const RegisterView(),
        notesRoute:(context)=>const NotesView(),
      },
    ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
   Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
          switch (snapshot.connectionState){
            
            case ConnectionState.done:
              final user=FirebaseAuth.instance.currentUser;
              // print(user);
              if(user!=null){
                if(user.emailVerified){
                  return const NotesView();
                }else{
                  return const VerifyEmailView();
                }
              }else{
                  return const LoginView();
              }
           
            default:
              return const CircularProgressIndicator();

          }
      },
      
      );
  }
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}
enum MenuAction {logout}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        backgroundColor: Colors.blueAccent,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value)async{
              switch(value){
                
                case MenuAction.logout:
                  final shouldLogout=await showLogOutDialog(context);
                  if(shouldLogout){
                    await FirebaseAuth.instance.signOut();
                    if (!context.mounted) return;
                    Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }
                  // devtools.log(shouldLogout.toString());
                  break;
                default:
                devtools.log("adfa");
              }
          },
          itemBuilder: (context){
            return const [
           PopupMenuItem<MenuAction>(
              value: MenuAction.logout,
              child: Text("sign out"),
            )
            ];
          },)
        ],),
      body: Container(padding:const EdgeInsets.all(12.0),
      margin: const EdgeInsets.all(12.0),
      height: 50,
      decoration:BoxDecoration(border: Border.all(width:2,color:const Color.fromARGB(255, 26, 173, 23))),
      
      child: const Center(child:  Text("done"))),
    );
  }
}

Future<bool>showLogOutDialog(BuildContext context){
  return showDialog(
    context:context,
    builder:(context){
      return AlertDialog(
        title: const Text("Sign Out"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop(false);
          }, child: const Text("Cancel")),
          TextButton(onPressed: (){
            Navigator.of(context).pop(true);
          }, child: const Text("Log Out")),
        ],
      );
    }
  ).then((value)=>value??false);
}