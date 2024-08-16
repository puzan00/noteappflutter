import 'package:flutter/material.dart';
import 'package:notetaking/model/note_model.dart';
import 'package:notetaking/service/note_service.dart';

import 'edit_note_screen.dart';

class ViewNoteScreen extends StatelessWidget {
  final Note note;
  final NoteService _noteService = NoteService();

  ViewNoteScreen({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNoteScreen(note: note),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await _noteService.deleteNote(note.id!);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey.shade800,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              note.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  note.content,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
