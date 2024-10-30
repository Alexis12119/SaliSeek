import 'package:SaliSeek/course_tile.dart';
import 'package:SaliSeek/main.dart';
import 'package:flutter/material.dart';

class ViewGradeDetails extends StatelessWidget {
  final String title;

  const ViewGradeDetails({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color(0xFFF2F8FC), // Set the background color to white
          child: Column(
            children: [
              // Retain the header
              buildHeader(context),

              // Title of the selected semester
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24.0, // Larger font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // List of course tiles with course name and grades
              Expanded(
                child: ListView.builder(
                  itemCount: 10, // Display 10 tiles
                  itemBuilder: (context, index) {
                    return const CourseTile(
                      courseCode: 'IT 101',
                      courseName: 'Programming Fundamentals',
                      midtermGrade: '1.00',
                      finalGrade: '1.00',
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reuse the header from the main window
  Widget buildHeader(BuildContext context) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Set font size, padding, and icon/avatar sizes based on the screen width
    double fontSize = screenWidth < 600 ? 10.0 : 18.0; // Font size for title
    double subtitleFontSize =
        screenWidth < 600 ? 9.0 : 12.0; // Font size for subtitle
    double padding =
        screenWidth < 600 ? 12.0 : 16.0; // Padding for narrow screens
    double iconSize = screenWidth < 600 ? 15.0 : 20.0; // Back icon size
    double logoIconSize = screenWidth < 600 ? 20.0 : 30.0; // Logo size

    return Container(
      color: const Color(0xFF2C9B44),
      padding: EdgeInsets.all(padding), // Responsive padding
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: iconSize, // Responsive icon size
            ),
            onPressed: () {
              Navigator.pop(context); // Go back to the previous screen
            },
          ),
          SizedBox(width: screenWidth < 600 ? 2.0 : 6.0), // Responsive spacing

          // Logo
          CircleAvatar(
            radius: logoIconSize, // Responsive avatar size
            backgroundColor: const Color(0xFFF2F8FC),
            child: Icon(
              Icons.school,
              size: logoIconSize,
              color: Colors.green, // Icon color
            ),
          ),
          SizedBox(width: screenWidth < 600 ? 12.0 : 16.0), // Spacing

          // Column with title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pamantasan ng Lungsod ng San Pablo',
                  style: TextStyle(
                    fontSize: fontSize, // Responsive title font size
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0), // Space between title and subtitle

                // Subtitle text
                Text(
                  'Brgy. San Jose, San Pablo City',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: const Color(0xFFF2F8FC),
                  ),
                ),
                Text(
                  'Tel No: (049) 536-7380',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: const Color(0xFFF2F8FC),
                  ),
                ),
                Text(
                  'Email Address: plspofficial@plsp.edu.ph',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: const Color(0xFFF2F8FC),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

