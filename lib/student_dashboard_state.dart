import 'package:SaliSeek/class_tile.dart';
import 'package:SaliSeek/course_details.dart';
import 'package:SaliSeek/login_page.dart';
import 'package:SaliSeek/semester_tile.dart';
import 'package:SaliSeek/main.dart';
import 'package:SaliSeek/student_dashboard.dart';
import 'package:SaliSeek/view_grade_details.dart';
import 'package:flutter/material.dart';

class StudentDashboardState extends State<StudentDashboard> {
  final ScrollController _gradeScrollController = ScrollController();
  final ScrollController _courseScrollController = ScrollController();
  final ScrollController _archivedScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with logo and title
              buildHeader(),

              // Profile Section
              buildProfileSection(),

// View Grades Section
              buildSectionWithArrows(
                title: 'View Grades:',
                scrollController: _gradeScrollController,
                items: [
                  '1st Year 1st Semester',
                  '1st Year 2nd Semester',
                  '2nd Year 1st Semester',
                  '2nd Year 2nd Semester',
                  '3rd Year 1st Semester',
                  '3rd Year 2nd Semester',
                  '4th Year 1st Semester',
                  '4th Year 2nd Semester',
                ],
                onTilePressed: (title) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewGradeDetails(title: title),
                    ),
                  );
                },
                tileType: (title) =>
                    SemesterTile(title), // Use SemesterTile here
              ),

// Courses Section
              buildSectionWithArrows(
                title: 'Courses:',
                scrollController: _courseScrollController,
                items: [
                  'Understanding the Self',
                  'Mathematics In the Modern World',
                  'Programming Fundamentals',
                  'Data Structures and Algorithms',
                  'Database Systems',
                  'Computer Networks',
                  'Software Engineering',
                  'Web Development',
                ],
                onTilePressed: (title) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseDetails(title: title),
                    ),
                  );
                },
                tileType: (title) => ClassTile(title), // Use ClassTile here
              ),

// Archived Classes Section
              buildSectionWithArrows(
                title: 'Archived Classes:',
                scrollController: _archivedScrollController,
                items: [
                  'History of Art',
                  'Introduction to Psychology',
                  'Ethics in Technology',
                  'Web Design Basics',
                  'Digital Marketing Strategies',
                ],
                onTilePressed: (title) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseDetails(title: title),
                    ),
                  );
                },
                tileType: (title) => ClassTile(title), // Use ClassTile here
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Header with logo and university name
  Widget buildHeader() {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Set font size, padding, spacing, and logo icon size based on the screen width
    double fontSize =
        screenWidth < 600 ? 10.0 : 18.0; // Smaller font for narrow screens
    double subtitleFontSize =
        screenWidth < 600 ? 9.0 : 12.0; // Adjust subtitle font size
    double padding =
        screenWidth < 600 ? 12.0 : 16.0; // Smaller padding for narrow screens
    double spacing =
        screenWidth < 600 ? 12.0 : 16.0; // Adjust spacing for narrow screens
    double logoIconSize =
        screenWidth < 600 ? 20.0 : 30.0; // Adjust the size of the logo icon

    return Container(
      color: const Color(0xFF2C9B44),
      padding: EdgeInsets.all(padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: logoIconSize, // Responsive size for logo
                backgroundColor: const Color(0xFFF2F8FC),
                child:
                    Icon(Icons.school, size: logoIconSize, color: Colors.green),
              ),
              SizedBox(width: spacing), // Responsive spacing

              // Column for title and subtitles
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pamantasan ng Lungsod ng San Pablo',
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                      height: 4.0), // Space between title and subtitle lines

                  // Subtitle lines
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
            ],
          ),

          // Logout button
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Show confirmation dialog before logging out
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Logout',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    content: const Text('Are you sure you want to log out?'),
                    backgroundColor: const Color(0xFF2C9B44).withOpacity(0.9),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('No',
                            style: TextStyle(color: Colors.black)),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                      TextButton(
                        child: const Text('Yes',
                            style: TextStyle(color: Colors.black)),
                        onPressed: () {
                          // Implement logout functionality here
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // Profile section
  Widget buildProfileSection() {
    return Container(
      color: const Color(0xFFF2F8FC),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Center(
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center items within the Row
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 50, color: Colors.green),
            ),
            const SizedBox(width: 16.0),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: Unknown',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Student ID: 12-345',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget for sections with arrows
  Widget buildSectionWithArrows({
    required String title,
    required ScrollController scrollController,
    required List<String> items,
    required Function(String)? onTilePressed,
    required Widget Function(String) tileType,
  }) {
    return Container(
      color: const Color(0xFFF2F8FC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with its own padding
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Padding around the box with tiles
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: SizedBox(
              height: 150,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final tile = tileType(items[index]);

                        return Padding(
                          padding: tile is SemesterTile
                              ? const EdgeInsets.symmetric(
                                  horizontal:
                                      2.0) // Additional spacing for SemesterTile
                              : const EdgeInsets.symmetric(
                                  horizontal:
                                      2.0), // Default spacing for other tiles
                          child: GestureDetector(
                            onTap: onTilePressed != null
                                ? () => onTilePressed(items[index])
                                : null,
                            child: tile,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

