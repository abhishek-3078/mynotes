import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/dialogs/logout_dialog.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';

import '../../enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  // ! =>  "null-aware access" operator.
  // String get userEmail => AuthService.firebase().currentUser!.email;
  String get userId => AuthService.firebase().currentUser!.id;
  late final FirebaseCloudStorage _notesService;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createUpdateNoteRoute);
              },
              icon: const Icon(Icons.add)),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    // await AuthService.firebase().logOut();
                    if (!context.mounted) return;
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                    // Navigator.of(context)
                    //     .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }
                  // devtools.log(shouldLogout.toString());
                  break;
                default:
                  
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("sign out"),
                )
              ];
            },
          )
        ],
      ),
      body: StreamBuilder(
                    stream: _notesService.allNotes(ownerUserId: userId),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          
                          if (snapshot.hasData) {
                            
                            final allNotes =
                                snapshot.data as Iterable<CloudNote>;
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.withAlpha(125)
                              ),
                              child: NotesListView(
                                notes: allNotes,
                                onDeleteNote: (note) async {
                                  await _notesService.deleteNote(documentId: note.documentId);
                                },
                                onTap: (note) {
                                  Navigator.of(context).pushNamed(
                                      createUpdateNoteRoute,
                                      arguments: note);
                                },
                              ),
                            );
                          }
                          else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }  else {
                            return  const Center(
                                child:  CircularProgressIndicator(),
                              
                            );
                          }

                        default:
                          return const CircularProgressIndicator();
                      }
                    }
                    )
    );
  }
}
