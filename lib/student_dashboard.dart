import 'package:SaliSeek/class_tile.dart';
import 'package:SaliSeek/course_details.dart';
import 'package:SaliSeek/login_page.dart';
import 'package:SaliSeek/semester_tile.dart';
import 'package:SaliSeek/view_grade_details.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class Course {
  final String id;
  final String name;
  final String code;
  final int semester;
  final int yearNumber;

  Course({
    required this.id,
    required this.name,
    required this.code,
    required this.semester,
    required this.yearNumber,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'].toString(),
      name: json['name'],
      code: json['code'],
      semester: int.parse(json['semester'].toString()),
      yearNumber: int.parse(json['year_number'].toString()),
    );
  }

  String get displayName => '$name ($code)';
}

class Section {
  final String id;
  final String name;
  final String programId;
  final int yearNumber;
  final int semester;

  Section({
    required this.id,
    required this.name,
    required this.programId,
    required this.yearNumber,
    required this.semester,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'].toString(),
      name: json['name'].toString(),
      programId: json['program_id'].toString(),
      yearNumber: int.parse(json['year_number'].toString()),
      semester: int.parse(json['semester'].toString()),
    );
  }

  String get displayName {
    String yearString;
    String semesterString;
    switch (yearNumber) {
      case 1:
        yearString = '1st';
        break;
      case 2:
        yearString = '2nd';
        break;
      case 3:
        yearString = '3rd';
        break;
      default:
        yearString = '${yearNumber}th';
    }
    switch (semester) {
      case 1:
        semesterString = '1st';
        break;
      case 2:
        semesterString = '2nd';
        break;
      case 3:
        semesterString = '3rd';
        break;
      default:
        semesterString = '${semester}th';
    }
    return '$yearString Year $semesterString Semester';
  }
}

class StudentDashboard extends StatefulWidget {
  final String studentId;
  const StudentDashboard({super.key, required this.studentId});

  @override
  StudentDashboardState createState() => StudentDashboardState();
}

class StudentDashboardState extends State<StudentDashboard> {
  final ScrollController _gradeScrollController = ScrollController();
  final ScrollController _courseScrollController = ScrollController();
  final ScrollController _archivedScrollController = ScrollController();
  String? _studentName;
  String? _studentNumber;
  String? _profileImageUrl;
  List<Section> _sections = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSections();
    _loadCourses();
    _loadStudentProfile(); // New method
  }

  List<Course> _courses = [];
  bool _isLoadingCourses = true;

  Future<void> _loadStudentProfile() async {
    try {
      final studentResponse = await Supabase.instance.client
          .from('students')
          .select('last_name, id')
          .eq('id', widget.studentId)
          .single();

      setState(() {
        _studentName = '${studentResponse['last_name']}';
        _studentNumber = studentResponse['id'].toString();
      });
    } catch (e) {
      print('Error loading student profile: $e');
      setState(() {
        _studentName = 'Unable to load name';
        _studentNumber = 'Unknown';
      });
    }
  }

  Widget buildProfileSection() {
    return Container(
      color: const Color(0xFFF2F8FC),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[300],
              backgroundImage: _profileImageUrl != null
                  ? NetworkImage(_profileImageUrl!)
                  : null,
              child: _profileImageUrl == null
                  ? const Icon(Icons.person, size: 50, color: Colors.green)
                  : null,
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _studentName ?? 'Loading...',
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Student ID: ${_studentNumber ?? 'Unknown'}',
                  style: const TextStyle(
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

  List<Course> _archivedCourses = [];

  Future<void> _loadCourses() async {
    try {
      // Fetch the student's current year and semester
      final studentResponse = await Supabase.instance.client
          .from('students')
          .select('section:section_id (year_number, semester)')
          .eq('id', widget.studentId)
          .single();

      final currentYear =
          int.parse(studentResponse['section']['year_number'].toString());
      final currentSemester =
          int.parse(studentResponse['section']['semester'].toString());

      // Fetch courses
      final response = await Supabase.instance.client
          .from('student_courses')
          .select('course:course_id (id, name, code, semester, year_number)')
          .eq('student_id', widget.studentId);

      final courses = (response as List)
          .map((data) => Course.fromJson(data['course']))
          .toList();

      // Separate courses into active and archived
      final activeCourses = courses
          .where((course) => (course.yearNumber == currentYear &&
              course.semester == currentSemester))
          .toList();

      final archivedCourses = courses
          .where((course) =>
              course.yearNumber < currentYear ||
              (course.yearNumber == currentYear &&
                  course.semester < currentSemester))
          .toList();

      setState(() {
        _courses = activeCourses;
        _archivedCourses = archivedCourses;
        _isLoadingCourses = false;
      });
    } catch (e) {
      print('Error loading courses: $e');
      setState(() {
        _isLoadingCourses = false;
      });
    }
  }

  Future<void> _loadSections() async {
    try {
      // First, fetch the student's details including program and current year
      final studentResponse = await Supabase.instance.client
          .from('students')
          .select('program_id, section:section_id (year_number)')
          .eq('id', widget.studentId)
          .single();

      final programId = studentResponse['program_id'].toString();
      final currentYear =
          int.parse(studentResponse['section']['year_number'].toString());

      // Fetch sections that match the student's program
      final response = await Supabase.instance.client
          .from('section')
          .select()
          .eq('program_id', programId)
          .lte('year_number',
              currentYear) // Only fetch sections up to current year
          .order('year_number')
          .order('semester');

      final sections = (response as List)
          .map((section) => Section.fromJson(section))
          .toList();

      setState(() {
        _sections = sections;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading sections: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

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
              buildGradeSection(),

              // Active Classes Section
              buildSectionWithArrows(
                title: 'Courses:',
                scrollController: _courseScrollController,
                items: _isLoadingCourses
                    ? [] // Show a loading indicator when data is loading
                    : _courses.map((course) => course.displayName).toList(),
                onTilePressed: (title) {
                  final selectedCourse = _courses
                      .firstWhere((course) => course.displayName == title);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseDetails(
                        title: selectedCourse.name,
                        studentId: widget.studentId,
                        courseId: selectedCourse.id,
                      ),
                    ),
                  );
                },
                tileType: (title) =>
                    ClassTile(title), // Use ClassTile for display
              ),

              // Archived Classes Section
              buildSectionWithArrows(
                title: 'Archived Classes:',
                scrollController: _archivedScrollController,
                items: _isLoadingCourses
                    ? [] // Show a loading indicator when data is loading
                    : _archivedCourses
                        .map((course) => course.displayName)
                        .toList(),
                onTilePressed: (title) {
                  final selectedCourse = _archivedCourses
                      .firstWhere((course) => course.displayName == title);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseDetails(
                        title: selectedCourse.name,
                        studentId: widget.studentId,
                        courseId: selectedCourse.id,
                      ),
                    ),
                  );
                },
                tileType: (title) =>
                    ClassTile(title), // Use ClassTile for display
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGradeSection() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Container(
      color: const Color(0xFFF2F8FC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'View Grades:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: SizedBox(
              height: 150,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _gradeScrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: _sections.length,
                      itemBuilder: (context, index) {
                        final section = _sections[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewGradeDetails(
                                    title: section.displayName,
                                    studentId: int.parse(widget.studentId),
                                  ),
                                ),
                              );
                            },
                            child: SemesterTile(section.displayName),
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
                backgroundImage: const AssetImage('assets/images/plsp.jpg'),
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
  // Widget buildProfileSection() {
  //   return Container(
  //     color: const Color(0xFFF2F8FC),
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
  //     child: Center(
  //       child: Row(
  //         mainAxisAlignment:
  //             MainAxisAlignment.center, // Center items within the Row
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           CircleAvatar(
  //             radius: 40,
  //             backgroundColor: Colors.grey[300],
  //             child: const Icon(Icons.person, size: 50, color: Colors.green),
  //           ),
  //           const SizedBox(width: 16.0),
  //           const Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 'Name: Unknown',
  //                 style: TextStyle(
  //                   fontSize: 18.0,
  //                   color: Colors.black,
  //                 ),
  //               ),
  //               SizedBox(height: 8.0),
  //               Text(
  //                 'Student ID: 12-345',
  //                 style: TextStyle(
  //                   fontSize: 16.0,
  //                   color: Colors.black,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
