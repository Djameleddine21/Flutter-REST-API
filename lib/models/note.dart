class Note {
  String noteId;
  String noteTitle;
  String noteContent;
  DateTime dateCreate;
  DateTime lastEdit;

  Note({
    this.noteId,
    this.noteTitle,
    this.noteContent,
    this.dateCreate,
    this.lastEdit,
  });

  factory Note.fromJson(Map<String, dynamic> item) {
    return Note(
      noteId: item['noteID'],
      noteTitle: item['noteTitle'],
      noteContent: item['noteContent'],
      dateCreate: DateTime.parse(item['createDateTime']),
      lastEdit: item['latestEditDateTime'] != null
          ? DateTime.parse(item['latestEditDateTime'])
          : null,
    );
  }
}
