import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  // Method to get the current logged-in user's ID
  String? _getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user's ID
    String? userId = _getCurrentUserId();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xFFDAC0A3)),
        backgroundColor: const Color(0xFF102C57),
      ),
      body: Container(
        color: const Color(0xFF102C57),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  const Text(
                    "Attendance",
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
            const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "DATE",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFFDAC0A3)),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "TIME-IN",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFFDAC0A3)),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "TIME-OUT",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFFDAC0A3)),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "STATUS",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFFDAC0A3)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const Divider(),
            // Fetch attendance data from Firestore and display it
            Expanded(
              child: userId == null
                  ? const Center(
                      child: Text(
                        "User not logged in!",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Attendance')
                          .where('userId', isEqualTo: userId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text(
                            'Error fetching data',
                            style: TextStyle(color: Colors.white),
                          ));
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                              child: Text(
                            'No attendance records found',
                            style: TextStyle(color: Colors.white),
                          ));
                        }

                        // Get the list of attendance documents
                        var attendanceDocs = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: attendanceDocs.length,
                          itemBuilder: (context, index) {
                            var attendance = attendanceDocs[index].data()
                                as Map<String, dynamic>;
                            String date = attendance['timestamp'] != null
                                ? (attendance['timestamp'] as Timestamp)
                                    .toDate()
                                    .toString()
                                    .split(' ')[0]
                                : 'N/A';
                            String timeIn = attendance['checkIn'] ?? 'N/A';
                            String timeOut = attendance['checkOut'] ?? 'N/A';
                            // Ensure status is "P" only when data is fetched successfully
                            String status = 'P';

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 3.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFF787880),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Text(
                                        date,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFFDAC0A3)),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFF787880),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Text(
                                        timeIn,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFFDAC0A3)),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFF787880),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Text(
                                        timeOut,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFFDAC0A3)),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFF787880),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Text(
                                        status, // Always show "P" as the status
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
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
