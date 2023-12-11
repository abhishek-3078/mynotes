
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import '../enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

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
                    await AuthService.firebase().logOut();
                    if (!context.mounted) return;
                    Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }
                  // devtools.log(shouldLogout.toString());
                  break;
                default:
                print("adfa");
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