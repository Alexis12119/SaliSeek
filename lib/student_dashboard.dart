import 'package:SaliSeek/class_tile.dart';
import 'package:SaliSeek/course_details.dart';
import 'package:SaliSeek/login_page.dart';
import 'package:SaliSeek/semester_tile.dart';
import 'package:SaliSeek/view_grade_details.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
// Students Table
// INSERT INTO "public"."students" ("id", "email", "password", "last_name", "type", "section_id", "program_id", "department_id", "grade_status") VALUES ('1', 'test@gmail.com', 'test123', 'Test', 'Regular', '2', '1', '1', 'Pending'), ('2', 'corporal461@gmail.com', 'Alexis-121', 'Alexis', 'Regular', '1', '1', '1', 'Pending');

// Teachers Table
// INSERT INTO "public"."teacher" ("id", "first_name", "email", "password", "last_name", "course_id") VALUES ('1', 'Hensonn', 'henz@gmail.com', 'admin', 'Palomado', '2'), ('2', 'Audrey', 'audrey@gmail.com', 'audrey123', 'Alinea', '3');

// College Course Table
// INSERT INTO "public"."college_course" ("id", "name", "year_number", "code", "semester") VALUES ('1', 'Networking 2', '2', 'NET212', '2'), ('2', 'Advanced Software Development', '3', 'ITProfEL1', '1'), ('3', 'Computer Programming 1', '1', 'CC111', '2'), ('4', 'Computer Programming 2', '1', 'CC112', '2'), ('5', 'Computer Programming 3', '2', 'CC123', '1'), ('6', 'Capstone 1', '3', 'CP111', '2'), ('7', 'Teleportation 1', '4', 'TP111', '1'), ('8', 'Teleportation 2', '4', 'TP222', '2'), ('9', 'Living in the IT Era', '1', 'LITE', '1');

// Student Courses Table
// INSERT INTO "public"."student_courses" ("student_id", "course_id", "midterm_grade") VALUES ('2', '3', '5'), ('2', '4', '5'), ('2', '9', '5');
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
  List<Course> _courses = [];
  bool _isLoadingCourses = true;

  final ScrollController _gradeScrollController = ScrollController();
  final ScrollController _courseScrollController = ScrollController();
  final ScrollController _archivedScrollController = ScrollController();
  String? _studentName;
  String? _studentNumber;
  String? _profileImageUrl;
  bool _isLoading = true;
  final List<RealtimeChannel> _subscriptions = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _setupRealtimeSubscriptions();
  }

  List<Section> _previousSemesters = [];

  List<Course> _archivedCourses = [];
  @override
  void dispose() {
    // Clean up subscriptions when disposing
    for (var subscription in _subscriptions) {
      subscription.unsubscribe();
    }
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _loadCourses(),
      _loadStudentProfile(),
      _loadPreviousSemesters(),
    ]);
  }

  void _setupRealtimeSubscriptions() {
  // Subscribe to student_courses changes
  final coursesChannel = Supabase.instance.client
      .channel('student_courses_changes')
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'student_courses',
        callback: (payload) async {
          // Reload everything that depends on student_courses
          await Future.wait([
            _loadCourses(),
            _loadPreviousSemesters(),
          ]);
        },
      )
      .subscribe();

  // Subscribe to college_course changes
  final collegeCoursesChannel = Supabase.instance.client
      .channel('college_course_changes')
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'college_course',
        callback: (payload) async {
          // Reload courses when college_course table changes
          await Future.wait([
            _loadCourses(),
            _loadPreviousSemesters(),
          ]);
        },
      )
      .subscribe();

  // Subscribe to students table for profile and section changes
  final profileChannel = Supabase.instance.client
      .channel('student_profile_changes')
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'students',
        callback: (payload) async {
          // Reload profile and courses (since section might have changed)
          await Future.wait([
            _loadStudentProfile(),
            _loadCourses(), // This needs to reload because active/archived status depends on current section
          ]);
        },
      )
      .subscribe();

  // Subscribe to section changes
  final sectionChannel = Supabase.instance.client
      .channel('section_changes')
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'sections',
        callback: (payload) async {
          // Reload courses when section information changes
          await _loadCourses();
        },
      )
      .subscribe();

  _subscriptions.addAll([
    coursesChannel,
    collegeCoursesChannel,
    profileChannel,
    sectionChannel,
  ]);
  }

  Future<void> _loadStudentProfile() async {
    try {
      final studentResponse = await Supabase.instance.client
          .from('students')
          .select('first_name, last_name, id')
          .eq('id', widget.studentId)
          .single();

      if (mounted) {
        setState(() {
          _studentName =
              '${studentResponse['first_name']} ${studentResponse['last_name']}';
          _studentNumber = studentResponse['id'].toString();
        });
      }
    } catch (e) {
      print('Error loading student profile: $e');
      if (mounted) {
        setState(() {
          _studentName = 'Unable to load name';
          _studentNumber = 'Unknown';
        });
      }
    }
  }

  Future<void> _loadCourses() async {
    try {
      final studentResponse = await Supabase.instance.client
          .from('students')
          .select('section:section_id (year_number, semester)')
          .eq('id', widget.studentId)
          .single();

      final currentYear =
          int.parse(studentResponse['section']['year_number'].toString());
      final currentSemester =
          int.parse(studentResponse['section']['semester'].toString());

      final response = await Supabase.instance.client
          .from('student_courses')
          .select('course:course_id (id, name, code, semester, year_number)')
          .eq('student_id', widget.studentId);

      final courses = (response as List)
          .map((data) => Course.fromJson(data['course']))
          .toList();

      final activeCourses = courses
          .where((course) =>
              course.yearNumber == currentYear &&
              course.semester == currentSemester)
          .toList();

      final archivedCourses = courses
          .where((course) =>
              course.yearNumber < currentYear ||
              (course.yearNumber == currentYear &&
                  course.semester < currentSemester))
          .toList();

      if (mounted) {
        setState(() {
          _courses = activeCourses;
          _archivedCourses = archivedCourses;
          _isLoadingCourses = false;
        });
      }
    } catch (e) {
      print('Error loading courses: $e');
      if (mounted) {
        setState(() {
          _isLoadingCourses = false;
        });
      }
    }
  }

  Future<void> _loadPreviousSemesters() async {
    try {
      final response = await Supabase.instance.client
          .from('student_courses')
          .select('course:course_id (year_number, semester)')
          .eq('student_id', widget.studentId);

      final courses = (response as List)
          .map((data) => Section.fromJson(data['course']))
          .toList();

      List<Section> uniqueSemesters = [];
      for (var course in courses) {
        if (!uniqueSemesters.any((existing) =>
            existing.yearNumber == course.yearNumber &&
            existing.semester == course.semester)) {
          uniqueSemesters.add(course);
        }
      }

      uniqueSemesters.sort((a, b) {
        if (a.yearNumber != b.yearNumber) {
          return a.yearNumber.compareTo(b.yearNumber);
        }
        return a.semester.compareTo(b.semester);
      });

      if (mounted) {
        setState(() {
          _previousSemesters = uniqueSemesters;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading previous semesters: $e');
    }
  }

// INSERT INTO "public"."student_courses" ("student_id", "course_id", "midterm_grade", "final_grade", "year_number", "semester") VALUES ('2', '3', '5', '5', '', ''), ('2', '4', '5', '5', '', ''), ('2', '9', '5', '5', '', '');

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
                title: 'Archived Courses:',
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
                      itemCount: _previousSemesters.length,
                      itemBuilder: (context, index) {
                        final semester = _previousSemesters[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewGradeDetails(
                                    title: semester.displayName,
                                    studentId: int.parse(widget.studentId),
                                    yearNumber: semester.yearNumber,
                                    semester: semester.semester,
                                  ),
                                ),
                              );
                            },
                            child: SemesterTile(semester.displayName),
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
