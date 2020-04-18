import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rest_api/services/notes_serive.dart';
import 'package:rest_api/views/note_list.dart';


void setupLocator(){
  GetIt.instance.registerLazySingleton(()=> NoteService());
}

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Rest Api',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoteList(),
    );
  }
}
