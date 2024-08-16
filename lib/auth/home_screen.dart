import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notetaking/model/note_model.dart';
import 'package:notetaking/screens/create_note_screen.dart';
import 'package:notetaking/screens/trash_screen.dart';
import 'package:notetaking/screens/view_note_screen.dart';
import 'package:notetaking/service/note_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NoteService _noteService = NoteService();
  final TextEditingController _searchController = TextEditingController();
  List<Note> _allNotes = [];
  List<Note> _filteredNotes = [];
  bool _isSearching = false;

  // Function to handle user logout
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  // Function to filter notes based on search query
  void _updateSearchResults(String query) {
    setState(() {
      _filteredNotes = _allNotes.where((note) {
        return note.title.toLowerCase().contains(query.toLowerCase()) ||
            note.content.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: _updateSearchResults,
              )
            : Text('My Notes', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          _isSearching
              ? IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _searchController.clear();
                      _filteredNotes = _allNotes; // Reset to show all notes
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Color(0xFF212121),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF212121),
              ),
              child: Center(
                child: Image.network(
                  'https://cdn-icons-png.flaticon.com/128/3131/3131636.png', // Note icon image
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.white),
              title: Text('Trash', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrashScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text('Logout', style: TextStyle(color: Colors.white)),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: Container(
        color: Color(0xFF303030),
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<List<Note>>(
          stream: _noteService.getNotes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child:
                      CircularProgressIndicator()); // Show loading indicator while waiting
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No notes yet',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              );
            }
            _allNotes = snapshot.data!;
            _filteredNotes = _isSearching ? _filteredNotes : _allNotes;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: _filteredNotes.length,
              itemBuilder: (context, index) {
                Note note = _filteredNotes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewNoteScreen(note: note),
                      ),
                    );
                  },
                  child: Card(
                    color: _getCardColor(index),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4.0),
                          Expanded(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                note.content,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateNoteScreen()),
          );
        },
        child: Icon(Icons.add, color: Colors.black),
        backgroundColor: Colors.white,
        shape: CircleBorder(
          side: BorderSide(color: Colors.black, width: 2.0),
        ),
      ),
    );
  }

  // Function to determine the color of each note card
  Color _getCardColor(int index) {
    List<Color> colors = [
      Colors.pinkAccent,
      Colors.redAccent,
      Colors.lightGreen,
      Colors.yellow[700]!,
      Colors.cyan[600]!,
      Colors.purple[400]!,
    ];
    return colors[index % colors.length];
  }
}
