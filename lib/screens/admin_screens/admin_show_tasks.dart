import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminShowTasks extends StatelessWidget {
  const AdminShowTasks({super.key});

  // Function to delete a task
  Future<void> deleteTask(BuildContext context, String docId) async {
    try {
      await FirebaseFirestore.instance.collection('Tasks').doc(docId).delete();
      // Optionally, show a Snackbar for feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Task deleted successfully")),
      );
    } catch (e) {
      print("Error deleting task: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete task")),
      );
    }
  }

  // Function to edit a task
  void editTask(BuildContext context, QueryDocumentSnapshot task) {
    // Extract task details from Firestore document
    TextEditingController titleController =
        TextEditingController(text: task['title']);
    TextEditingController descriptionController =
        TextEditingController(text: task['description']);
    TextEditingController teamNameController =
        TextEditingController(text: task['teamName']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Description"),
              ),
              TextField(
                controller: teamNameController,
                decoration: InputDecoration(labelText: "Team Name"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Update the task in Firestore using the document ID
                FirebaseFirestore.instance
                    .collection('Tasks')
                    .doc(task.id)
                    .update({
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'teamName': teamNameController.text,
                }).then((_) {
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Task updated successfully")),
                  );
                }).catchError((error) {
                  print("Error updating task: $error");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to update task")),
                  );
                });
              },
              child: Text("Save"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF102C57),
        iconTheme: IconThemeData(color: Color(0xFFDAC0A3)),
      ),
      body: Container(
        color: Color(0xFF102C57),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  Text(
                    "Tasks",
                    style: TextStyle(color: Color(0xFFDAC0A3), fontSize: 30),
                  ),
                  Container(
                    width: 250,
                    height: 1,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('Tasks').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No tasks available",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final tasks = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      var task = tasks[index]; // Using QueryDocumentSnapshot

                      return Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task['title'] ??
                                    'No Title', // Fetching 'title' field
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'ID: ${task.id}', // Fetching Firestore document ID
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                task['description'] ??
                                    'No Description', // Fetching 'description' field
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Team: ${task['teamName'] ?? 'No Team Name'}', // Fetching 'teamName' field
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              SizedBox(height: 16), // Space before buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => editTask(context, task),
                                    child: Text("Edit"),
                                  ),
                                  SizedBox(width: 8),
                                  TextButton(
                                    onPressed: () => deleteTask(context,
                                        task.id), // Use Firestore doc ID for deletion
                                    child: Text("Delete"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
