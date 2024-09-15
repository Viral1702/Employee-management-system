import 'package:flutter/material.dart';

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
                onChanged:
                    updateSearch, // Call the search function on input change
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredEmails.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                            style:
                                TextStyle(fontSize: 50, color: Colors.grey[50]),
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
