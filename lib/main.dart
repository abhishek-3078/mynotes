import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/login_view.dart';


void main() {
 
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage()
    ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:const Text('HomePage'),
        backgroundColor: Colors.blue
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
          switch (snapshot.connectionState){
            
            case ConnectionState.done:
              final user=FirebaseAuth.instance.currentUser;
              if(user?.emailVerified??false){
                print("You are a verified user");
              }else{
                print("You need to verify the email");
              }
              return Text("Done hai");
          
            default:
              return const Text('Loading...');

          }
      },
      
      ),
    );
  }
}

