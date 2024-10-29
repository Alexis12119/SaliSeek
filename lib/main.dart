import 'package:flutter/material.dart';
import 'dart:async';

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
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            // Center the column in the middle of the screen
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center the column
              children: [
                buildHeader(), // Header with logo and title
                Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            // Center the Login title
                            child: Text(
                              'Login', // Title text
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight:
                                      FontWeight.bold), // Style for the title
                            ),
                          ),
                          const SizedBox(
                              height: 20.0), // Spacing between title and form
                          const Text(
                            'Student ID',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4.0),
                          TextFormField(
                            controller: _studentIdController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your Student ID',
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
                          const Text(
                            'Password',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4.0),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          Center(
                            child: SizedBox(
                              width: 150, // Set a fixed width for the button
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2C9B44),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0), // Smaller height
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Rounded corners
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const StudentDashboard(),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFFF2F8FC),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0), // Spacing for the links
                          Center(
                            child: Column(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignUpPage()),
                                    );
                                  },
                                  child: const Text(
                                    "Don't have an account? Sign Up",
                                    style: TextStyle(
                                      color: Colors
                                          .black, // Change link color to black
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPasswordPage()),
                                    );
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: Colors
                                          .black, // Change link color to black
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 600 ? 14.0 : 18.0;
    double subtitleFontSize = screenWidth < 600 ? 10.0 : 12.0;
    double padding = screenWidth < 600 ? 12.0 : 16.0;
    double avatarSize = screenWidth < 600 ? 25.0 : 30.0;
    double spacing = screenWidth < 600 ? 12.0 : 16.0;

    return Container(
      color: const Color(0xFFF2F8FC),
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          CircleAvatar(
            radius: avatarSize,
            backgroundColor: const Color(0xFFF2F8FC),
            child: const Icon(Icons.school, size: 30, color: Colors.green),
          ),
          SizedBox(width: spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pamantasan ng Lungsod ng San Pablo',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Brgy. San Jose, San Pablo City',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Tel No: (049) 536-7380',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Email Address: plspofficial@plsp.edu.ph',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.black,
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

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildHeader(),
                Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          const Text(
                            'Student ID',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4.0),
                          TextFormField(
                            controller: _studentIdController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your Student ID',
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
                          const Text(
                            'Last Name',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4.0),
                          TextFormField(
                            controller: _lastNameController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your Last Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Last Name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          const Text(
                            'Email',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4.0),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your email address',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          const Text(
                            'Password',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4.0),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          Center(
                            child: SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2C9B44),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // Handle sign up logic here
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const StudentDashboard(),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFFF2F8FC),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Go back to Login page
                              },
                              child: const Text(
                                'Already have an account? Login',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 600 ? 14.0 : 18.0;
    double subtitleFontSize = screenWidth < 600 ? 10.0 : 12.0;
    double padding = screenWidth < 600 ? 12.0 : 16.0;
    double avatarSize = screenWidth < 600 ? 25.0 : 30.0;
    double spacing = screenWidth < 600 ? 12.0 : 16.0;

    return Container(
      color: const Color(0xFFF2F8FC),
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          CircleAvatar(
            radius: avatarSize,
            backgroundColor: const Color(0xFFF2F8FC),
            child: const Icon(Icons.school, size: 30, color: Colors.green),
          ),
          SizedBox(width: spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pamantasan ng Lungsod ng San Pablo',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Brgy. San Jose, San Pablo City',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Tel No: (049) 536-7380',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Email Address: plspofficial@plsp.edu.ph',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.black,
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

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isButtonDisabled = false;
  String _buttonText = "Send OTP";
  String _timerText = ""; // Timer text to indicate remaining time
  int _remainingTime = 10; // 10 seconds countdown

  void _sendOtp() {
    // Disable button and start timer for 10 seconds
    setState(() {
      _isButtonDisabled = true;
      _buttonText = "Resend";
      _timerText = "Resend in $_remainingTime s";
    });

    // Start a timer that counts down every second
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 1) {
        setState(() {
          _remainingTime--;
          _timerText = "Resend in $_remainingTime s";
        });
      } else {
        timer.cancel(); // Stop the timer
        setState(() {
          _isButtonDisabled = false;
          _buttonText = "Send OTP";
          _timerText = ""; // Clear the timer text
          _remainingTime = 10; // Reset the remaining time
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FC),
      body: SafeArea(
        child: Column(
          children: [
            buildHeader(), // Header at the very top
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(36.0),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20.0),
                          const Center(
                            child: Text(
                              'Forgot Password',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          const Text(
                            'Email Address',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your email address',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: _isButtonDisabled ? null : _sendOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2C9B44),
                                ),
                                child: Text(
                                  _buttonText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // Displaying the timer text
                              if (_timerText.isNotEmpty)
                                Text(
                                  _timerText,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Center(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2C9B44),
                                ),
                                onPressed: () {
                                  // Handle the submit action here
                                },
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                              height: 20.0), // Spacing for the back link
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Go back to login page
                              },
                              child: const Text(
                                'Back to Login',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 600 ? 14.0 : 18.0;
    double subtitleFontSize = screenWidth < 600 ? 10.0 : 12.0;
    double padding = screenWidth < 600 ? 12.0 : 16.0;
    double avatarSize = screenWidth < 600 ? 25.0 : 30.0;
    double spacing = screenWidth < 600 ? 12.0 : 16.0;

    return Container(
      color: const Color(0xFFF2F8FC),
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          CircleAvatar(
            radius: avatarSize,
            backgroundColor: const Color(0xFFF2F8FC),
            child: const Icon(Icons.school, size: 30, color: Colors.green),
          ),
          SizedBox(width: spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pamantasan ng Lungsod ng San Pablo',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Brgy. San Jose, San Pablo City',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Tel No: (049) 536-7380',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Email Address: plspofficial@plsp.edu.ph',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.black,
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

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  StudentDashboardState createState() => StudentDashboardState();
}

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
        screenWidth < 600 ? 14.0 : 18.0; // Smaller font for narrow screens
    double subtitleFontSize =
        screenWidth < 600 ? 10.0 : 12.0; // Adjust subtitle font size
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
  }) {
    return Container(
        color: const Color(0xFFF2F8FC),
        child: Column(
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
        ));
  }
}

// Semester/Course Tile Widget
class SemesterTile extends StatelessWidget {
  final String title;

  const SemesterTile(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
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
    double fontSize = screenWidth < 600 ? 14.0 : 18.0; // Font size for title
    double subtitleFontSize =
        screenWidth < 600 ? 10.0 : 12.0; // Font size for subtitle
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

class CourseDetails extends StatelessWidget {
  final String title;

  const CourseDetails({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final List<String> modules =
        List.generate(10, (index) => 'Module ${index + 1}');

    final List<Map<String, String>> tasksAndActivities = List.generate(
      10,
      (index) => {
        'name': 'Task ${index + 1}',
        'description': 'Description of Task ${index + 1}',
        'dueDate': 'Oct. 20'
      },
    );

    Widget buildSectionWithArrows({
      required ScrollController scrollController,
      required List<String> items,
      required Function(String)? onTilePressed,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 100,
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

    Widget buildTasksAndActivities() {
      return Container(
          color: const Color(0xFFF2F8FC),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tasks and Activities:',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: tasksAndActivities.length,
                    itemBuilder: (context, index) {
                      final task = tasksAndActivities[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey[300],
                                  child: const Icon(Icons.person,
                                      color: Colors.green),
                                ),
                                const SizedBox(width: 8.0),
                                const Text(
                                  'Student Name',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                const Spacer(), // Added to push due date to the end
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Due (${task['dueDate']})',
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12.0),
                            const SizedBox(height: 4.0),
                            Row(children: [
                              // Task Details
                              Text(
                                task['description']!,
                                style: const TextStyle(fontSize: 14.0),
                              ),
                              const Spacer(),
                              const SizedBox(height: 8.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                            const SizedBox(height: 16.0),
                            // See Details at bottom right
                            Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const DetailsPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'See Details',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ));
    }

    final ScrollController moduleScrollController = ScrollController();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FC),
      body: SafeArea(
        child: Column(
          children: [
            buildHeader(context),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  child:
                      const Icon(Icons.person, size: 20, color: Colors.green),
                ),
                const SizedBox(width: 8.0),
                const Text(
                  'Instructor: John Doe',
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 0.0),
              child: Text(
                'Learning Materials:',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16.0),
            buildSectionWithArrows(
              scrollController: moduleScrollController,
              items: modules,
              onTilePressed: (title) {},
            ),
            Expanded(child: buildTasksAndActivities()),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 600 ? 14.0 : 18.0;
    double subtitleFontSize =
        screenWidth < 600 ? 10.0 : 12.0; // Subtitle font size
    double padding = screenWidth < 600 ? 12.0 : 16.0;
    double iconSize = screenWidth < 600 ? 15.0 : 20.0;
    double iconPadding = screenWidth < 600 ? 0.0 : 8.0;
    double logoSize = screenWidth < 600 ? 20.0 : 30.0;
    double logoIconSize = screenWidth < 600 ? 20.0 : 30.0;

    return Container(
      color: const Color(0xFF2C9B44),
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(iconPadding),
            child: IconButton(
              iconSize: iconSize,
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(width: screenWidth < 600 ? 2.0 : 6.0),

          // Logo
          CircleAvatar(
            radius: logoSize,
            backgroundColor: const Color(0xFFF2F8FC),
            child: Icon(Icons.school, size: logoIconSize, color: Colors.green),
          ),

          const SizedBox(width: 8.0),

          // Column for Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pamantasan ng Lungsod ng San Pablo',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0), // Space between title and subtitle

                // Subtitle details
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

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  List<SubmittedFile> submittedFiles = [];
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildHeader(context),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 24.0),
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Due Date: October 30, 2024',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.warning_amber_rounded,
                                color: Colors.red, size: 20.0),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                'Submit before the due date to avoid penalties.',
                                style: TextStyle(
                                    color: Colors.red, fontSize: 14.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      const Text(
                        'Task Description',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Write a report on the impacts of technology on education.',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      const SizedBox(height: 24.0),
                      // File Upload Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Your Submission',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (submittedFiles.isNotEmpty)
                                TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      submittedFiles.clear();
                                    });
                                  },
                                  icon: const Icon(Icons.delete_outline,
                                      size: 20),
                                  label: const Text('Clear all'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          InkWell(
                            onTap: _isUploading ? null : _handleFileUpload,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 48.0,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(height: 12.0),
                                  Text(
                                    _isUploading
                                        ? 'Uploading...'
                                        : 'Click to upload your file',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Supported formats: PDF, DOC, DOCX, PPT, PPTX, XLS, XLSX',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          // Display uploaded files
                          ...submittedFiles.map((file) => _buildFileItem(file)),
                          if (submittedFiles.isNotEmpty) ...[
                            const SizedBox(height: 24.0),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Assignment submitted successfully!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2C9B44),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text(
                                  'Submit Assignment',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFFF2F8FC),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileItem(SubmittedFile file) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(_getFileIcon(file.fileType),
              color: _getFileColor(file.fileType), size: 24.0),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.fileName,
                  style: const TextStyle(
                      fontSize: 14.0, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Uploaded ${_formatDate(file.uploadTime)} • ${file.fileSize}',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              setState(() {
                submittedFiles.remove(file);
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleFileUpload() async {
    // Simulate file upload
    setState(() => _isUploading = true);

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isUploading = false;
      submittedFiles.add(
        SubmittedFile(
          fileName: 'Assignment_Report.docx',
          fileSize: '2.5 MB',
          uploadTime: DateTime.now(),
          fileType: 'docx',
        ),
      );
    });

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File uploaded successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  IconData _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileColor(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'ppt':
      case 'pptx':
        return Colors.orange;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget buildHeader(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 600 ? 14.0 : 18.0;
    double subtitleFontSize =
        screenWidth < 600 ? 10.0 : 12.0; // Subtitle font size
    double padding = screenWidth < 600 ? 12.0 : 16.0;
    double iconSize = screenWidth < 600 ? 15.0 : 20.0;
    double iconPadding = screenWidth < 600 ? 0.0 : 8.0;
    double logoSize = screenWidth < 600 ? 20.0 : 30.0;
    double logoIconSize = screenWidth < 600 ? 20.0 : 30.0;

    return Container(
      color: const Color(0xFF2C9B44),
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(iconPadding),
            child: IconButton(
              iconSize: iconSize,
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(width: screenWidth < 600 ? 2.0 : 6.0),

          // Logo
          CircleAvatar(
            radius: logoSize,
            backgroundColor: const Color(0xFFF2F8FC),
            child: Icon(Icons.school, size: logoIconSize, color: Colors.green),
          ),

          const SizedBox(width: 8.0),

          // Column for Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pamantasan ng Lungsod ng San Pablo',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0), // Space between title and subtitle

                // Subtitle details
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

class SubmittedFile {
  final String fileName;
  final String fileSize;
  final DateTime uploadTime;
  final String fileType;

  SubmittedFile({
    required this.fileName,
    required this.fileSize,
    required this.uploadTime,
    required this.fileType,
  });
}
