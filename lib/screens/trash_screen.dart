import 'package:flutter/material.dart';
import 'package:notetaking/model/note_model.dart';
import 'package:notetaking/service/note_service.dart';

class TrashScreen extends StatelessWidget {
  final NoteService _noteService = NoteService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trash', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey[900],
        child: StreamBuilder<List<Note>>(
          stream: _noteService.getDeletedNotes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No deleted notes',
                    style: TextStyle(color: Colors.white)),
              );
            }

            // Display the list of deleted notes
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Note note = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    title:
                        Text(note.title, style: TextStyle(color: Colors.white)),
                    subtitle: Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[300]),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Restore button
                        IconButton(
                          icon:
                              Icon(Icons.restore, color: Colors.green.shade400),
                          onPressed: () async {
                            await _noteService.restoreNote(note.id!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Note restored')),
                            );
                          },
                        ),
                        // Permanently delete button
                        IconButton(
                          icon: Icon(Icons.delete_forever,
                              color: Colors.red.shade400),
                          onPressed: () async {
                            await _noteService.permanentlyDeleteNote(note.id!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Note permanently deleted')),
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      // Show a dialog with the full note content
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(note.title,
                              style: TextStyle(color: Colors.white)),
                          content: Text(note.content,
                              style: TextStyle(color: Colors.white70)),
                          backgroundColor: Colors.grey[850],
                          actions: [
                            TextButton(
                              child: Text('Close',
                                  style:
                                      TextStyle(color: Colors.yellow.shade500)),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
