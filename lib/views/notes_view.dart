
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';

import '../enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {

  // ! =>  "null-aware access" operator. 
  String get userEmail => AuthService.firebase().currentUser!.email!;
  late final NotesService _notesService;
  
  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }



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
      body:FutureBuilder(
      future: _notesService.getOrCreateUser(email: userEmail), 
      builder:(context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.done:
            return StreamBuilder(stream: _notesService.allNotes, builder: (context,snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.waiting:
                  return const Text("Waiting for all notes to appear");
                default:
                  return const CircularProgressIndicator();
              }
            });
          default:
            return const CircularProgressIndicator();
        }
      } ),
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