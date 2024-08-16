import 'package:flutter/material.dart';
import 'package:notetaking/model/note_model.dart';
import 'package:notetaking/service/note_service.dart';

class CreateNoteScreen extends StatefulWidget {
  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final NoteService _noteService = NoteService();

  // Save the note to the database and go back to the previous screen.
  void _saveNote() async {
    // Check if either title or content is not empty
    if (_titleController.text.isNotEmpty ||
        _contentController.text.isNotEmpty) {
      // Create a new note object.
      Note newNote = Note(
        title: _titleController.text,
        content: _contentController.text,
      );

      // Add the new note to the database.
      await _noteService.addNote(newNote);

      // Go back to the previous screen.
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Note', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.black),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Container(
        color: Colors.grey.shade800,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: Colors.white70),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow.shade500),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _contentController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Note content',
                  hintStyle: TextStyle(color: Colors.white70),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow.shade500),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
