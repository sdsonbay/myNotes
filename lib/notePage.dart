import 'package:flutter/material.dart';
import 'package:flutter_note/homePage.dart';
import 'package:flutter_note/inherited_widgets/note_inherited_widgets.dart';
import 'package:flutter_note/providers/note_provider.dart';

enum NoteMode {
  EditingMode,
  AddingMode,
}

class NotePage extends StatefulWidget {
  final NoteMode noteMode;
  final Map<String, dynamic> note;
  NotePage(this.noteMode, this.note);

  @override
  NotePageState createState() {
    return new NotePageState();
  }
}

class NotePageState extends State<NotePage> {
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _contentTextController = TextEditingController();

  List<Map<String, String>> get _notes => NoteInheritedWidget.of(context).notes;

  @override
  void didChangeDependencies() {
    if (widget.noteMode == NoteMode.EditingMode) {
      _titleTextController.text = widget.note['title'];
      _contentTextController.text = widget.note['content'];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
            widget.noteMode == NoteMode.AddingMode ? 'Add Note' : 'Edit Note'),
        actions: [
          FlatButton(
              padding: EdgeInsets.symmetric(horizontal: 8),
              onPressed: () {
                final title = _titleTextController.text;
                final content = _contentTextController.text;
                if (widget?.noteMode == NoteMode.AddingMode) {
                  NoteProvider.insertNote({
                    'title': title,
                    'content': content,
                  });
                } else if (widget?.noteMode == NoteMode.EditingMode) {
                  NoteProvider.updateNote({
                    'id': widget.note['id'],
                    'title': _titleTextController.text,
                    'content': _contentTextController.text,
                  });
                }
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Icon(
                Icons.save,
                color: Colors.white,
              )),
          FlatButton(
              padding: EdgeInsets.symmetric(horizontal: 8),
              onPressed: () async {
                if (widget.noteMode == NoteMode.AddingMode) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                } else {
                  await NoteProvider.deleteNote(widget.note['id']);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                }
              },
              child: Icon(
                Icons.delete,
                color: Colors.white,
              )),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: new BoxDecoration(
              color: Colors.blueGrey[900],
              borderRadius: BorderRadius.circular(25),
            ),
            margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _titleTextController,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hoverColor: Colors.white,
                hintText: 'Title',
                hintStyle: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.40),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.blueGrey[900],
                borderRadius: BorderRadius.circular(25),
              ),
              margin: EdgeInsets.fromLTRB(10, 10, 10, 25),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _contentTextController,
                style: TextStyle(color: Colors.white),
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: 'Content',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.40),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
