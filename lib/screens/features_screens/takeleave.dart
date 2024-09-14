import 'package:flutter/material.dart';

class takeLeave extends StatelessWidget {
  const takeLeave({super.key});

  @override
  Widget build(BuildContext context) {
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
                    "Take Leave",
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildInputField("Reson"),
                  buildInputField("Enter a Description"),
                  buildInputField("From", Icon: Icon(Icons.calendar_month)),
                  buildInputField("To", Icon: Icon(Icons.calendar_month)),
                  buildInputField("Choose File",
                      width: 140, Icon: Icon(Icons.file_copy)),
                  SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle form submission here
                      },
                      child: Text(
                        "Apply",
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

  Widget buildInputField(String label,
      {double height = 30, double width = double.infinity, Icon}) {
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
            width: width,
            decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(5)),
            height: height,
            child: TextField(
              decoration: InputDecoration(
                suffixIcon: Icon,
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
