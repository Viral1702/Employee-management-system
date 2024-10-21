import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditHolidays extends StatefulWidget {
  @override
  _EditHolidaysState createState() => _EditHolidaysState();
}

class _EditHolidaysState extends State<EditHolidays> {
  final CollectionReference<Map<String, dynamic>> holidaysCollection =
      FirebaseFirestore.instance.collection('Holidays');

  List<Map<String, String>> holidays = [];
  bool isLoading = true;

  // Text controllers for adding new festival and date
  TextEditingController newFestivalController = TextEditingController();
  TextEditingController newDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchHolidays();
  }

  Future<void> _fetchHolidays() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await holidaysCollection.get();
      setState(() {
        holidays = snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  'festival': doc.data()['festival'] as String,
                  'date': doc.data()['date'] as String,
                })
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching holidays: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to add new holiday
  Future<void> _addHoliday() async {
    if (newFestivalController.text.isNotEmpty &&
        newDateController.text.isNotEmpty) {
      // Add to Firestore
      DocumentReference docRef = await holidaysCollection.add({
        'festival': newFestivalController.text,
        'date': newDateController.text,
      });

      // Add to local list
      setState(() {
        holidays.add({
          'id': docRef.id,
          'festival': newFestivalController.text,
          'date': newDateController.text,
        });
        // Clear the input fields after adding
        newFestivalController.clear();
        newDateController.clear();
      });
    }
  }

  // Function to show Edit Popup dialog
  Future<void> _showEditDialog(int index) async {
    TextEditingController festivalController =
        TextEditingController(text: holidays[index]['festival']);
    TextEditingController dateController =
        TextEditingController(text: holidays[index]['date']);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Holiday'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: festivalController,
                decoration: InputDecoration(labelText: 'Festival'),
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Date'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel the dialog
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Update the holiday in Firestore
                String docId = holidays[index]['id']!;
                await holidaysCollection.doc(docId).update({
                  'festival': festivalController.text,
                  'date': dateController.text,
                });

                // Update the local list
                setState(() {
                  holidays[index]['festival'] = festivalController.text;
                  holidays[index]['date'] = dateController.text;
                });

                Navigator.pop(context); // Close the dialog
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to show confirmation dialog for delete
  Future<void> _showDeleteDialog(int index) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this holiday?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel the dialog
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Delete the holiday from Firestore
                String docId = holidays[index]['id']!;
                await holidaysCollection.doc(docId).delete();

                // Update the local list
                setState(() {
                  holidays.removeAt(index);
                });

                Navigator.pop(context); // Close the dialog
              },
              child: Text('Delete'),
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
        iconTheme: IconThemeData(color: Color(0xFFDAC0A3)),
        backgroundColor: Color(0xFF102C57), // AppBar background color
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: Color(0xFF102C57), // Background color for body
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        Text(
                          "Holidays",
                          style:
                              TextStyle(color: Color(0xFFDAC0A3), fontSize: 30),
                        ),
                        Container(
                          width: 250,
                          height: 1,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: newFestivalController,
                          decoration: InputDecoration(
                            labelText: 'New Festival',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          controller: newDateController,
                          decoration: InputDecoration(
                            labelText: 'New Date',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity, // Set the width to infinity
                          child: ElevatedButton(
                            onPressed: _addHoliday,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color(0xFFDAC0A3), // Button color
                              padding: EdgeInsets.symmetric(vertical: 15),
                              textStyle:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            child: Text('Add Holiday',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: holidays.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.all(10),
                          color: Colors.white, // Card background color
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  holidays[index]['festival']!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      holidays[index]['date']!,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () =>
                                              _showEditDialog(index),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () =>
                                              _showDeleteDialog(index),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
