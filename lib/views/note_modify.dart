import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rest_api/models/note.dart';
import 'package:rest_api/models/notes_insert.dart';
import 'package:rest_api/services/notes_serive.dart';

class NoteModify extends StatefulWidget {
  final String noteID;
  NoteModify({this.noteID});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteID != null;

  NoteService get noteService => GetIt.instance<NoteService>();
  String errorMessage;
  Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      setState(() {
        _isLoading = true;
      });

      noteService.getNote(widget.noteID).then((response) {
        setState(() {
          _isLoading = false;
        });
        if (response.error) {
          errorMessage = response.errorMessage ?? "An error occurred";
        }
        note = response.data;
        titleController.text = note.noteTitle;
        contentController.text = note.noteContent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(!isEditing ? "Create Note" : "Edit Note"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: <Widget>[
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(hintText: "Note title"),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: contentController,
                      decoration: InputDecoration(hintText: "Note Content"),
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (isEditing) {
                            setState(() {
                              _isLoading = true;
                            });

                            final _note = NoteInsert(
                              noteTitle: titleController.text,
                              noteContent: contentController.text,
                            );
                            final result = await noteService.updateNote(widget.noteID,_note);
                            setState(() {
                              _isLoading = false;
                            });
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text("Done"),
                                content: Text(result.error
                                    ? (result.errorMessage ?? "Error")
                                    : "Your node was updated"),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("OK"))
                                ],
                              ),
                            ).then((_) {
                              if (result.data) {
                                Navigator.of(context).pop();
                              }
                            });
                          } else {
                            setState(() {
                              _isLoading = true;
                            });

                            final _note = NoteInsert(
                              noteTitle: titleController.text,
                              noteContent: contentController.text,
                            );
                            final result = await noteService.createNote(_note);
                            setState(() {
                              _isLoading = false;
                            });
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text("Done"),
                                content: Text(result.error
                                    ? (result.errorMessage ?? "Error")
                                    : "Your node was created"),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("OK"))
                                ],
                              ),
                            ).then((_) {
                              if (result.data) {
                                Navigator.of(context).pop();
                              }
                            });
                          }
                          // Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
