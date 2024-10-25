import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:worknest/screens/features_screens/attendance.dart';

class Employees extends StatefulWidget {
  const Employees({super.key});

  @override
  _EmployeesState createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> employees = [];
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredEmployees = [];

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    QuerySnapshot snapshot = await _firestore.collection('Users').get();
    setState(() {
      employees = snapshot.docs
          .map((doc) => {
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id // Add document ID
              })
          .toList();
      filteredEmployees = List.from(employees);
    });
  }

  void updateSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredEmployees = List.from(employees);
      } else {
        filteredEmployees = employees.where((employee) {
          return (employee['name']?.toLowerCase() ?? '')
                  .contains(query.toLowerCase()) ||
              (employee['email']?.toLowerCase() ?? '')
                  .contains(query.toLowerCase()) ||
              (employee['position']?.toLowerCase() ?? '')
                  .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _navigateToSingleEmployee(Map<String, dynamic> employee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SingleEmployee(
          employeeId: employee['id'], // Pass employee ID
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
                onChanged: updateSearch,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredEmployees.length,
                itemBuilder: (context, index) {
                  final employee = filteredEmployees[index];
                  return GestureDetector(
                    onTap: () => _navigateToSingleEmployee(employee),
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
                            Image.asset('assets/images/login_avatar.png'),
                            SizedBox(width: 10),
                            Text("  |  ",
                                style: TextStyle(
                                    fontSize: 50, color: Colors.grey[50])),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    employee['name'] ?? 'No Name Available',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(employee['email'] ??
                                      'No Email Available'),
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

// SingleEmployee screen with edit functionality
class SingleEmployee extends StatefulWidget {
  final String employeeId;

  SingleEmployee({required this.employeeId});

  @override
  _SingleEmployeeState createState() => _SingleEmployeeState();
}

class _SingleEmployeeState extends State<SingleEmployee> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController teamController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEmployeeData();
  }

  Future<void> fetchEmployeeData() async {
    DocumentSnapshot employeeDoc =
        await _firestore.collection('Users').doc(widget.employeeId).get();
    if (employeeDoc.exists) {
      Map<String, dynamic> data = employeeDoc.data() as Map<String, dynamic>;
      setState(() {
        nameController.text = data['name'] ?? '';
        emailController.text = data['email'] ?? '';
        positionController.text = data['position'] ?? '';
        salaryController.text = data['salary'] ?? '';
        teamController.text = data['teamName'] ?? '';
        isLoading = false;
      });
    }
  }

  Future<void> saveChanges() async {
    if (_formKey.currentState!.validate()) {
      await _firestore.collection('Users').doc(widget.employeeId).update({
        'name': nameController.text,
        'email': emailController.text,
        'position': positionController.text,
        'salary': salaryController.text,
        'teamName': teamController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Changes saved successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFFDAC0A3)),
        backgroundColor: Color(0xFF102C57),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Color(0xFF102C57), // Background color for full screen
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/login_avatar.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      _buildStyledTextField(
                        label: 'Name',
                        controller: nameController,
                        validatorMessage: 'Name is required',
                      ),
                      _buildStyledTextField(
                        label: 'Email',
                        controller: emailController,
                        validatorMessage: 'Email is required',
                      ),
                      _buildStyledTextField(
                        label: 'Position',
                        controller: positionController,
                        validatorMessage: 'Position is required',
                      ),
                      _buildStyledTextField(
                        label: 'Salary',
                        controller: salaryController,
                        validatorMessage: 'Salary is required',
                      ),
                      _buildStyledTextField(
                        label: 'Team Name',
                        controller: teamController,
                        validatorMessage: 'Team name is required',
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: saveChanges,
                        child: Text('Save Changes',
                            style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFDAC0A3),
                          minimumSize: Size(double.infinity, 36),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AttendanceScreen()));
                        },
                        child: Text('View Attendance',
                            style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFDAC0A3),
                          minimumSize: Size(double.infinity, 36),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildStyledTextField({
    required String label,
    required TextEditingController controller,
    required String validatorMessage,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFD9D9D9),
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validatorMessage;
          }
          return null;
        },
      ),
    );
  }
}
