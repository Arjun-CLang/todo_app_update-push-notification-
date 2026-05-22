import 'package:flutter/material.dart';
import 'package:notification_demo/send_notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final nameController = TextEditingController();
  List<String> notes = [];
  void  addNote() async {
    final title = nameController.text.trim();
    
    if (title.isEmpty) return;
    nameController.clear();

    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => SendNotificationScreen()));
  }

  void updateNote(String docId, String currrentTitle) {
    final editController = TextEditingController(text: currrentTitle);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Note"),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(hintText: "enter new note"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                editController.clear();
              },
              child: Text("cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: Text("ADD"),
            ),
          ],
        );
      },
    );
  }

  void deleteNote(String docId) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CRUD Oprations")),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                label: Text("enter Note"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: addNote,
              label: Text("Add Note"),
              icon: Icon(Icons.add),
              style: ElevatedButton.styleFrom(
                maximumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
