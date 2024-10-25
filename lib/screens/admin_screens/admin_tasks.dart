import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:worknest/screens/admin_screens/admin_show_tasks.dart'; // Import Firestore package

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the form fields
  TextEditingController nameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController teamNameController = TextEditingController();

  // Firestore instance
  final CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('Tasks');

  // Function to add task to Firestore
  Future<void> addTaskToFirestore() async {
    try {
      await tasksCollection.add({
        'name': nameController.text,
        'title': titleController.text,
        'description': descriptionController.text,
        'teamName': teamNameController.text,
      });

      // Clear the text fields after successful submission
      nameController.clear();
      titleController.clear();
      descriptionController.clear();
      teamNameController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Task Added Successfully")),
      );
    } catch (e) {
      print("Error adding task: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add task")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF102C57), // Set the Scaffold background color
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFFDAC0A3)),
        backgroundColor: Color(0xFF102C57),
        title: Text('Add Task', style: TextStyle(color: Color(0xFFDAC0A3))),
      ),
      body: SingleChildScrollView(
        // Wrap the content with SingleChildScrollView
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30), // Optional padding
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    Text(
                      "Add Tasks",
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
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ID Field

                      // Name Field
                      _buildTextField(
                        controller: nameController,
                        label: 'Name',
                        hintText: 'Enter your name',
                      ),
                      SizedBox(height: 15),

                      // Title Field
                      _buildTextField(
                        controller: titleController,
                        label: 'Title',
                        hintText: 'Enter task title',
                      ),
                      SizedBox(height: 15),

                      // Description Field
                      _buildTextField(
                        controller: descriptionController,
                        label: 'Description',
                        hintText: 'Enter task description',
                      ),
                      SizedBox(height: 15),

                      // Team Name Field
                      _buildTextField(
                        controller: teamNameController,
                        label: 'Team Name',
                        hintText: 'Enter your team name',
                      ),
                      SizedBox(height: 30),

                      // Add Task Button
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Add task to Firebase Firestore
                            addTaskToFirestore();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFDAC0A3),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Text(
                          'Add Task',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      // Show Tasks ....
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminShowTasks()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 194, 191, 188),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          textStyle: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        child: Text(
                          'Show all Tasks',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom Text Field Widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        hintStyle: TextStyle(color: Colors.grey),
      ),
      style: TextStyle(fontSize: 16),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }
}
