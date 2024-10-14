import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildHeader(), // Header with logo and title
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _studentIdController,
                        decoration: const InputDecoration(
                          labelText: 'Student ID',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Student ID';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Process login (you can replace this with your own logic)
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StudentDashboard(),
                              ),
                            );
                          }
                        },
                        child: const Text('Login'),
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

  // Header with logo and university name
  Widget buildHeader() {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Set font size and padding based on the screen width
    double fontSize =
        screenWidth < 600 ? 16.0 : 18.0; // Smaller font for narrow screens
    double padding =
        screenWidth < 600 ? 12.0 : 16.0; // Smaller padding for narrow screens
    double avatarSize = screenWidth < 600
        ? 25.0
        : 30.0; // Adjust avatar size for narrow screens
    double spacing =
        screenWidth < 600 ? 12.0 : 16.0; // Adjust spacing for narrow screens

    return Container(
      color: const Color(0xFF266A2D),
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          CircleAvatar(
            radius: avatarSize, // Responsive size for logo
            backgroundColor: Colors.white,
            child: const Icon(Icons.school, size: 30, color: Colors.green),
          ),
          SizedBox(width: spacing), // Responsive spacing
          Text(
            'Pamantasan ng Lungsod ng San Pablo',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  StudentDashboardState createState() => StudentDashboardState();
}

class StudentDashboardState extends State<StudentDashboard> {
  final ScrollController _gradeScrollController = ScrollController();
  final ScrollController _courseScrollController = ScrollController();

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

    // Set font size, padding, avatar size, and spacing based on the screen width
    double fontSize =
        screenWidth < 600 ? 16.0 : 18.0; // Smaller font for narrow screens
    double padding =
        screenWidth < 600 ? 12.0 : 16.0; // Smaller padding for narrow screens
    double avatarSize = screenWidth < 600
        ? 25.0
        : 30.0; // Adjust avatar size for narrow screens
    double spacing =
        screenWidth < 600 ? 12.0 : 16.0; // Adjust spacing for narrow screens

    return Container(
      color: const Color(0xFF266A2D),
      padding: EdgeInsets.all(padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: avatarSize, // Responsive size for logo
                backgroundColor: Colors.white,
                child: const Icon(Icons.school, size: 30, color: Colors.green),
              ),
              SizedBox(width: spacing), // Responsive spacing
              Text(
                'Pamantasan ng Lungsod ng San Pablo',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Show confirmation dialog before logging out
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                      TextButton(
                        child: const Text('Yes'),
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
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person, size: 50, color: Colors.white),
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
                'Student ID: 123345',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget for sections with arrows
  Widget buildSectionWithArrows({
    required String title,
    required ScrollController scrollController,
    required List<String> items,
    required Function(String)? onTilePressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        SizedBox(
          height: 150,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  scrollController.animateTo(
                    scrollController.offset - 150,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: onTilePressed != null
                          ? () => onTilePressed(items[index])
                          : null,
                      child: SemesterTile(items[index]),
                    );
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  scrollController.animateTo(
                    scrollController.offset + 150,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Semester/Course Tile Widget
class SemesterTile extends StatelessWidget {
  final String title;

  const SemesterTile(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: const Color(0xFF266A2D),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ViewGradeDetails Page with Back Button
class ViewGradeDetails extends StatelessWidget {
  final String title;

  const ViewGradeDetails({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                itemCount: 5, // Display 5 tiles
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
    );
  }

  // Reuse the header from the main window
  Widget buildHeader(BuildContext context) {
    return Container(
      color: const Color(0xFF266A2D),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context); // Go back to the previous screen
            },
          ),
          const SizedBox(width: 16.0),

          // Logo and university name
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.school, size: 30, color: Colors.green),
          ),
          const SizedBox(width: 16.0),
          const Text(
            'Pamantasan ng Lungsod ng San Pablo',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// Course tile widget in square format
class CourseTile extends StatelessWidget {
  final String courseCode;
  final String courseName;
  final String midtermGrade;
  final String finalGrade;

  const CourseTile({
    super.key,
    required this.courseCode,
    required this.courseName,
    required this.midtermGrade,
    required this.finalGrade,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: const Color(0xFFE0E0E0), // Light gray background for the tile
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Course Code and Name inside a Column, left side
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courseCode,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(courseName),
                ],
              ),
              // Grades side, aligned to the right
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        midtermGrade,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                          width: 24.0), // Spacing between Midterm and Finals
                      Text(
                        finalGrade,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      Text(
                        'Midterm',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(width: 20.0),
                      Text(
                        'Finals',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModuleTileSection extends StatefulWidget {
  final List<String> modules;

  const ModuleTileSection({super.key, required this.modules});

  @override
  ModuleTileSectionState createState() => ModuleTileSectionState();
}

class ModuleTileSectionState extends State<ModuleTileSection> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.3); // Adjust the viewport fraction for three tiles
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose the controller when no longer needed
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < (widget.modules.length / 3).ceil() - 1) {
      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {}); // Update state to reflect current page
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {}); // Update state to reflect current page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SizedBox(
            height: 150, // Adjust height to align with arrow buttons
            child: PageView.builder(
              controller: _pageController,
              itemCount: (widget.modules.length / 3).ceil(), // Number of pages based on the number of tiles
              itemBuilder: (context, index) {
                // Create a row of three tiles for each page
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(3, (tileIndex) {
                    final moduleIndex = index * 3 + tileIndex; // Calculate the module index
                    if (moduleIndex < widget.modules.length) {
                      return ModuleTile(
                        moduleTitle: widget.modules[moduleIndex],
                        onNext: _nextPage,
                        onPrevious: _previousPage,
                      );
                    }
                    return const SizedBox.shrink(); // Return an empty widget if there are no more modules
                  }),
                );
              },
            ),
          ),
          // Navigation Arrows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: _previousPage,
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                  onPressed: _nextPage,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ModuleTile extends StatelessWidget {
  final String moduleTitle;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const ModuleTile({
    super.key,
    required this.moduleTitle,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0), // Adjust vertical padding
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFF266A2D), // Background color
          borderRadius: BorderRadius.circular(12.0), // Slightly rounded corners
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0), // Consistent padding with semester tile
            child: Text(
              moduleTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold, // Use bold for emphasis
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CourseDetails extends StatelessWidget {
  final String title;

  const CourseDetails({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Example list of modules
    final List<String> modules =
        List.generate(10, (index) => 'Module ${index + 1}');

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Retain the header
            buildHeader(context),

            // Course Name
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

            // Instructor's name and profile logo
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  child:
                      const Icon(Icons.person, size: 20, color: Colors.white),
                ),
                const SizedBox(width: 8.0),
                const Text(
                  'Instructor: John Doe',
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),

            // Learning materials title
            const Padding(
              padding:
                  EdgeInsets.only(top: 16.0, bottom: 8.0), // Adjusted padding
              child: Text(
                'Learning Materials:',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),

            // Learning materials (modules)
            Expanded(
              child: ModuleTileSection(modules: modules),
            ),
          ],
        ),
      ),
    );
  }

  // Reuse the header from the main window
  Widget buildHeader(BuildContext context) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Set font size and padding based on the screen width
    double fontSize =
        screenWidth < 600 ? 16.0 : 18.0; // Smaller font for narrow screens
    double padding =
        screenWidth < 600 ? 12.0 : 16.0; // Smaller padding for narrow screens

    return Container(
      color: const Color(0xFF266A2D),
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context); // Go back to the previous screen
            },
          ),
          const SizedBox(width: 8.0), // Adjusted spacing

          // Logo and university name
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.school, size: 30, color: Colors.green),
          ),
          const SizedBox(width: 8.0), // Adjusted spacing

          // University name with responsive font size
          Text(
            'Pamantasan ng Lungsod ng San Pablo',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
