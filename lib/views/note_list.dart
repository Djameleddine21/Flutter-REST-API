import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rest_api/models/api_response.dart';
import 'package:rest_api/models/note.dart';
import 'package:rest_api/services/notes_serive.dart';
import 'package:rest_api/views/note_delete.dart';
import 'package:rest_api/views/note_modify.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NoteService get service => GetIt.instance<NoteService>();
  APIResponse<List<Note>> _apiResponse;
  bool _isLoading = false;

  String formatDateTime(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getNotesList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("List of notes"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => NoteModify()));
            },
            child: Icon(Icons.add),
          ),
          body: Builder(
            builder: (_) {
              if (_isLoading) {
                return Center(child: CupertinoActivityIndicator(radius: 30.0,));
              }
              else {
                if (_apiResponse.error) {
                  return Center(child :Text(_apiResponse.errorMessage ?? "Error..."));
                }
                return ListView.separated(
                  itemCount: _apiResponse.data.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.green),
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: ValueKey(_apiResponse.data[index].noteId),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {},
                      confirmDismiss: (direction) async {
                        final result = await showDialog(
                            context: context, builder: (_) => NoteDelete());
                          if(result){
                            final deleteResult = await service.deleteNote(_apiResponse.data[index].noteId);
                            String message;
                            if (deleteResult.data ==true && deleteResult != null) {
                              message = "The note was delete";
                            }
                            else{
                              message = deleteResult?.errorMessage ?? "An error occured";
                            }
                            showDialog(context: context,builder:(_)=> AlertDialog(
                              title: Text("Done"),
                              content: Text(message),
                              actions: <Widget>[
                                FlatButton(onPressed: (){
                                  Navigator.of(context).pop();
                                }, child: Text('OK'))
                              ],
                            ));
                            return deleteResult?.data ?? false;
                          }
                        return result;
                      },
                      background: Container(
                        color: Colors.red,
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          _apiResponse.data[index].noteTitle,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        subtitle: Text(
                            "Last edit on ${formatDateTime(_apiResponse.data[index].lastEdit ?? _apiResponse.data[index].dateCreate)}"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NoteModify(
                                noteID: _apiResponse.data[index].noteId,
                              ),
                            ),
                          ).then((_)=> _fetchNotes());
                        },
                      ),
                    );
                  },
                );
              }
            },
          )),
    );
  }
}
