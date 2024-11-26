import 'package:flutter/material.dart';
import 'package:SaliSeek/course_tile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Teachers Table
// INSERT INTO "public"."teacher" ("id", "first_name", "email", "password", "last_name") VALUES ('1', 'Hensonn', 'henz@gmail.com', 'admin', 'Palomado'), ('2', 'Audrey', 'audrey@gmail.com', 'audrey123', 'Alinea');

// College Course Table
// INSERT INTO "public"."college_course" ("id", "name", "year_number", "code", "semester") VALUES ('1', 'Networking 2', '2', 'NET212', '2'), ('2', 'Advanced Software Development', '3', 'ITProfEL1', '1'), ('3', 'Computer Programming 1', '1', 'CC111', '2'), ('4', 'Computer Programming 2', '1', 'CC112', '2'), ('5', 'Computer Programming 3', '2', 'CC123', '1'), ('6', 'Capstone 1', '3', 'CP111', '2'), ('7', 'Teleportation 1', '4', 'TP111', '1'), ('8', 'Teleportation 2', '4', 'TP222', '2'), ('9', 'Living in the IT Era', '1', 'LITE', '1');

// Student Courses Table
// INSERT INTO "public"."student_courses" ("student_id", "course_id", "midterm_grade") VALUES ('2', '3', '5'), ('2', '4', '5'), ('2', '9', '5');

class Course {
  final String courseCode;
  final String courseTitle;
  final String midtermGrade;
  final String status;

  Course({
    required this.courseCode,
    required this.courseTitle,
    required this.midtermGrade,
    required this.status,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseCode: json['course_code'].toString(),
      courseTitle: json['course_title'].toString(),
      midtermGrade: json['midterm_grade'].toString(),
      status: json['status'].toString(),
    );
  }
}

class ViewGradeDetails extends StatefulWidget {
  final String title;
  final int studentId;
  final int yearNumber;
  final int semester;

  const ViewGradeDetails({
    super.key,
    required this.title,
    required this.studentId,
    required this.yearNumber,
    required this.semester,
  });

  @override
  ViewGradeDetailsState createState() => ViewGradeDetailsState();
}

class ViewGradeDetailsState extends State<ViewGradeDetails> {
  final supabase = Supabase.instance.client;
  final List<RealtimeChannel> _subscriptions = [];

  List<Course>? _courses;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _setupRealtimeSubscriptions();
  }

  @override
  void dispose() {
    for (var subscription in _subscriptions) {
      subscription.unsubscribe();
    }
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    await fetchCourses();
  }

  void _setupRealtimeSubscriptions() {
    // Subscribe to student_courses changes
    final studentCoursesChannel = supabase
        .channel('student_courses_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'student_courses',
          callback: (payload) => fetchCourses(),
        )
        .subscribe();

    // Subscribe to college_course changes
    final collegeCoursesChannel = supabase
        .channel('college_courses_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'college_course',
          callback: (payload) => fetchCourses(),
        )
        .subscribe();

    _subscriptions.addAll([studentCoursesChannel, collegeCoursesChannel]);
  }

  Future<void> fetchCourses() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final courseResponse = await supabase
          .from('college_course')
          .select('id, name, code, year_number, semester')
          .eq('year_number', widget.yearNumber)
          .eq('semester', widget.semester);

      if (!mounted) return;

      if (courseResponse.isEmpty) {
        setState(() {
          _courses = [];
          _isLoading = false;
        });
        return;
      }

      final studentCoursesResponse = await supabase
          .from('student_courses')
          .select('course_id, midterm_grade, status')
          .eq('student_id', widget.studentId);

      if (!mounted) return;

      final Map<int, dynamic> studentCoursesMap = {
        for (var course in studentCoursesResponse) course['course_id']: course
      };

      List<Course> courses = [];

      for (var courseData in courseResponse) {
        final courseId = courseData['id'];

        if (studentCoursesMap.containsKey(courseId)) {
          final studentCourse = studentCoursesMap[courseId];
          final status = studentCourse['status'];
          final midtermGrade =
              (status == 'Approved' && studentCourse['midterm_grade'] != null)
                  ? studentCourse['midterm_grade'].toString()
                  : 'Pending';

          courses.add(Course(
            courseCode: courseData['code'].toString(),
            courseTitle: courseData['name'].toString(),
            midtermGrade: midtermGrade,
            status: status,
          ));
        } else {
          final insertResponse = await supabase
              .from('student_courses')
              .insert({
                'student_id': widget.studentId,
                'course_id': courseId,
                'midterm_grade': 5.00,
                'final_grade': 5.00,
                'year_number': widget.yearNumber,
                'semester': widget.semester,
                'status': 'Pending',
              })
              .select('course_id, midterm_grade, status')
              .maybeSingle();

          if (insertResponse != null) {
            courses.add(Course(
              courseCode: courseData['code'].toString(),
              courseTitle: courseData['name'].toString(),
              midtermGrade: insertResponse['midterm_grade'].toString(),
              status: insertResponse['status'].toString(),
            ));
          }
        }
      }

      if (mounted) {
        setState(() {
          _courses = courses;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching courses: $e');
      if (mounted) {
        setState(() {
          _courses = [];
          _isLoading = false;
        });
      }
    }
  }

  Widget buildCoursesList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_courses == null || _courses!.isEmpty) {
      return const Center(child: Text('No courses found'));
    }

    return ListView.builder(
      itemCount: _courses!.length,
      itemBuilder: (context, index) {
        final course = _courses![index];

        final String midtermGradeDisplay;
        // Check if grade is pending
        if (course.status == 'Pending') {
          midtermGradeDisplay = "Pending";
        } else {
          midtermGradeDisplay = course.midtermGrade;
        }

        return CourseTile(
          courseCode: course.courseCode,
          courseName: course.courseTitle,
          midtermGrade: midtermGradeDisplay, // Pass the conditional value here
          status: course.status,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color(0xFFF2F8FC),
          child: Column(
            children: [
              buildHeader(context),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(child: buildCoursesList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 600 ? 10.0 : 18.0;
    double subtitleFontSize = screenWidth < 600 ? 9.0 : 12.0;
    double padding = screenWidth < 600 ? 12.0 : 16.0;
    double iconSize = screenWidth < 600 ? 15.0 : 20.0;
    double logoIconSize = screenWidth < 600 ? 20.0 : 30.0;

    return Container(
      color: const Color(0xFF2C9B44),
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: iconSize,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(width: screenWidth < 600 ? 2.0 : 6.0),
          CircleAvatar(
            radius: logoIconSize,
            backgroundColor: const Color(0xFFF2F8FC),
            backgroundImage: const AssetImage('assets/images/plsp.jpg'),
          ),
          SizedBox(width: screenWidth < 600 ? 12.0 : 16.0),
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
                const SizedBox(height: 4.0),
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
