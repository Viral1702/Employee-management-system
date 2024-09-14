import 'package:flutter/material.dart';

class EmployeeProfile extends StatelessWidget {
  const EmployeeProfile({super.key});

  @override
  Widget build(BuildContext context) {
    // User details for pre-filling the fields
    List<String> userDetails = [
      "Natasha",
      "example@gmail.com",
      "ABC-01",
      "8200860989",
      "Jr Dev",
      "50,000"
    ];

    // Corresponding labels for the fields
    List<String> fields = [
      "Name",
      "Email",
      "Team Name",
      "Phone Number",
      "Position",
      "Salary"
    ];

    return Scaffold(
      backgroundColor: Color(0xFF102C57),
      appBar: AppBar(
        backgroundColor: Color(0xFF102C57),
        iconTheme: IconThemeData(color: Color(0xFFDAC0A3)),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    "Edit Profile",
                    style: TextStyle(color: Color(0xFFDAC0A3), fontSize: 30),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 250,
                    height: 1,
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Profile Picture with Edit Icon
              Center(
                child: Stack(
                  children: [
                    // Circular Avatar
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          AssetImage("assets/images/login_avatar.png"),
                    ),
                    // Edit Icon
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          // Handle profile picture edit action here
                        },
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xFFDAC0A3),
                          child: Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // Input Fields
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0;
                      i < fields.length && i < userDetails.length;
                      i++)
                    buildInputField(fields[i], userDetails[i]),

                  SizedBox(height: 30),

                  // Submit button
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle form submission here
                      },
                      child: Text(
                        "Edit",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFDAC0A3),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build each input field with a pre-filled value
  Widget buildInputField(String label, String value) {
    TextEditingController _controller = TextEditingController(text: value);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFFDAC0A3),
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(5)),
            height: 50,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
