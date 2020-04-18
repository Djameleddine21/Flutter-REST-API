import 'dart:convert';

import 'package:rest_api/models/api_response.dart';
import 'package:rest_api/models/note.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api/models/notes_insert.dart';

class NoteService {
  static const api = "http://api.notes.programmingaddict.com";
  static const apiKey = "fa1abc16-ae5b-49c8-ab16-8015b8da29fa";

  static const headers = {
    "apiKey": "fe290471-568b-42b3-8399-38160fae09ec",
    "Content-Type": "application/json"
  };

  Future<APIResponse<List<Note>>> getNotesList() {
    return http.get(api + "/notes", headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final notes = <Note>[];
        for (var item in jsonData) {
          final note = Note(
            noteId: item['noteID'],
            noteTitle: item['noteTitle'],
            dateCreate: DateTime.parse(item['createDateTime']),
            lastEdit: item['latestEditDateTime'] != null
                ? DateTime.parse(item['latestEditDateTime'])
                : null,
          );
          notes.add(note);
        }
        return APIResponse<List<Note>>(data: notes);
      }
      return APIResponse<List<Note>>(
          error: true, errorMessage: "An error : ${data.statusCode}");
    }).catchError((_) =>
        APIResponse<List<Note>>(error: true, errorMessage: "An error occured"));
  }

  Future<APIResponse<Note>> getNote(String noteTD) {
    return http.get(api + "/notes/" + noteTD, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<Note>(data: Note.fromJson(jsonData));
      }
      return APIResponse<Note>(
          error: true, errorMessage: "An error : ${data.statusCode}");
    }).catchError((_) =>
        APIResponse<Note>(error: true, errorMessage: "An error occured"));
  }

  Future<APIResponse<bool>> createNote(NoteInsert note) {
    return http
        .post(api + "/notes",
            headers: headers, body: json.encode(note.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true, error: false);
      }
      return APIResponse<bool>(
          error: true, errorMessage: "An error : ${data.statusCode}");
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: "An error occured"));
  }

  Future<APIResponse<bool>> updateNote(String noteID, NoteInsert note) {
    return http
        .put(api + "/notes/" + noteID,
            headers: headers, body: json.encode(note.toJson()))
        .then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true, error: false);
      }
      return APIResponse<bool>(
          error: true, errorMessage: "An error : ${data.statusCode}");
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: "An error occured"));
  }

  Future<APIResponse<bool>> deleteNote(String noteID) {
    return http.delete(api + "/notes/" + noteID, headers: headers).then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true, error: false);
      }
      return APIResponse<bool>(
          error: true, errorMessage: "An error : ${data.statusCode}");
    }).catchError((_) =>
        APIResponse<bool>(error: true, errorMessage: "An error occured"));
  }
}
