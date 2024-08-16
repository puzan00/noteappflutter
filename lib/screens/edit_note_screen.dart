import 'package:flutter/material.dart';
import 'package:notetaking/model/note_model.dart';
import 'package:notetaking/service/note_service.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;

  EditNoteScreen({required this.note});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final NoteService _noteService = NoteService();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  void _updateNote() async {
    widget.note.title = _titleController.text;
    widget.note.content = _contentController.text;
    widget.note.updatedAt = DateTime.now();
    await _noteService.updateNote(widget.note);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.black),
            onPressed: _updateNote,
          ),
        ],
      ),
      body: Container(
        color: Colors.grey.shade800,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: Colors.white70),
                border: UnderlineInputBorder(
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
                  border: UnderlineInputBorder(
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
