import 'package:flutter/material.dart';
import 'package:flutter_note/providers/note_provider.dart';
import 'package:flutter_note/widgets.dart';
import 'notePage.dart';
import 'package:flutter_note/inherited_widgets/note_inherited_widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> get _notes => NoteInheritedWidget.of(context).notes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: defaultAppBar('Notes'),
      body: FutureBuilder(
          future: NoteProvider.getNoteList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final notes = snapshot.data;

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotePage(
                                  NoteMode.EditingMode, notes[index])));
                    },
                    child: Container(
                      decoration: new BoxDecoration(
                        color: Colors.blueGrey[900],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      margin: EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8, left: 10, right: 10, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: _NoteTitle(notes[index]['title']),
                            ),
                            Divider(
                              color: Colors.blueAccent.withAlpha(900),
                              thickness: 2,
                            ),
                            _NoteContent(notes[index]['content']),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: notes.length,
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NotePage(NoteMode.AddingMode, null)));
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}

class _NoteTitle extends StatelessWidget {
  final String _title;
  _NoteTitle(this._title);
  @override
  Widget build(BuildContext context) {
    return Text(
      _title,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _NoteContent extends StatelessWidget {
  final String _content;
  _NoteContent(this._content);
  @override
  Widget build(BuildContext context) {
    return Text(
      _content,
      style: TextStyle(color: Colors.grey.withAlpha(700)),
      maxLines: 7,
      overflow: TextOverflow.fade,
    );
  }
}
