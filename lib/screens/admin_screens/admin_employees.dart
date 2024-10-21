import 'package:flutter/material.dart';
import 'package:worknest/screens/features_screens/attendance.dart';

// Main function to run the app
class Employees extends StatefulWidget {
  const Employees({super.key});

  @override
  _EmployeesState createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  List<String> name = ["Viral", "Rajveer"];
  List<String> emails = ["viralshingadia38@gmail.com", "rjadeja440@gmail.com"];
  List<String> positions = ["JR DEV", "SR DEV"];
  List<String> images = [
    "assets/images/login_avatar.png",
    "assets/images/login_avatar.png"
  ];

  TextEditingController searchController = TextEditingController();
  List<String> filteredNames = [];
  List<String> filteredEmails = [];
  List<String> filteredPositions = [];

  @override
  void initState() {
    super.initState();
    // Initially show all employees
    filteredNames = List.from(name);
    filteredEmails = List.from(emails);
    filteredPositions = List.from(positions);
  }

  void updateSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        // If search query is empty, show all employees
        filteredNames = List.from(name);
        filteredEmails = List.from(emails);
        filteredPositions = List.from(positions);
      } else {
        // Filter the names and emails based on the search query
        filteredNames = [];
        filteredEmails = [];
        filteredPositions = [];

        for (int i = 0; i < name.length; i++) {
          if (name[i].toLowerCase().contains(query.toLowerCase()) ||
              emails[i].toLowerCase().contains(query.toLowerCase()) ||
              positions[i].toLowerCase().contains(query.toLowerCase())) {
            filteredNames.add(name[i]);
            filteredEmails.add(emails[i]);
            filteredPositions.add(positions[i]);
          }
        }
      }
    });
  }

  void _navigateToSingleEmployee(String employeeName, String employeeEmail) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SingleEmployee(
          employeeName: employeeName,
          employeeEmail: employeeEmail,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFFDAC0A3)),
        backgroundColor: Color(0xFF102C57),
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
                    "Employees",
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
            // Avatar Image

            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name or email...',
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 15),
                onChanged:
                    updateSearch, // Call the search function on input change
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredEmails.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _navigateToSingleEmployee(
                      filteredNames[index],
                      filteredEmails[index],
                    ),
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      height: 85,
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Image.asset(images[index]),
                            SizedBox(width: 10),
                            Text(
                              "  |  ",
                              style: TextStyle(
                                  fontSize: 50, color: Colors.grey[50]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    filteredNames[index],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(filteredEmails[index]),
                                ],
                              ),
                            ),
                          ],
                        ),
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

// SingleEmployee screen
class SingleEmployee extends StatelessWidget {
  final String employeeName;
  final String employeeEmail;

  SingleEmployee({required this.employeeName, required this.employeeEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Details'),
        backgroundColor: Color(0xFF102C57),
      ),
      body: Container(
        color: Color(0xFF102C57), // Background color for the entire body
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            // Login Avatar
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 20),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/login_avatar.png'), // Your avatar image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Input Fields
            _buildStyledTextField(label: 'Position'),
            _buildStyledTextField(label: 'Salary'),
            _buildStyledTextField(label: 'Admin Email'),
            _buildStyledTextField(label: 'Team Name'),
            SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add save changes functionality here
                  },
                  child: Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFDAC0A3), // Button color
                    minimumSize: Size(double.infinity, 36), // Set minimum size
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Attendance page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            attendanceScreen(), // Your Attendance page
                      ),
                    );
                  },
                  child: Text(
                    'Attendance',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFDAC0A3), // Button color
                    minimumSize: Size(double.infinity, 36), // Set minimum size
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledTextField({required String label}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(fontSize: 15),
      ),
    );
  }
}
