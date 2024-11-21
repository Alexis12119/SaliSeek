import 'package:flutter/material.dart';
import 'package:SaliSeek/course_tile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Course {
  final String courseCode;
  final String courseTitle;
  final String midtermGrade;
  final String finalGrade;
  final String semester;
  final String yearNumber;

  Course({
    required this.courseCode,
    required this.courseTitle,
    required this.midtermGrade,
    required this.finalGrade,
    required this.semester,
    required this.yearNumber,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseCode: json['course_code'].toString(),
      courseTitle: json['course_title'].toString(),
      midtermGrade: json['midterm_grade'].toString(),
      finalGrade: json['final_grade'].toString(),
      semester: json['semester'].toString(),
      yearNumber: json['year_number'].toString(),
    );
  }
}

class ViewGradeDetails extends StatefulWidget {
  final String title;
  final int studentId;

  const ViewGradeDetails(
      {super.key, required this.title, required this.studentId});

  @override
  ViewGradeDetailsState createState() => ViewGradeDetailsState();
}

class ViewGradeDetailsState extends State<ViewGradeDetails> {
  final supabase = Supabase.instance.client;

  late Future<List<Course>> futureCourses;

  @override
  void initState() {
    super.initState();
    futureCourses = fetchCourses();
  }

// Students Table
// INSERT INTO "public"."students" ("id", "email", "password", "last_name", "type", "section_id", "program_id", "department_id", "grade_status", "midterm_grade", "final_grade") VALUES ('1', 'test@gmail.com', 'test123', 'Test', 'Regular', '1', '1', '1', 'Pending', '5', '5'), ('2', 'corporal461@gmail.com', 'Alexis-121', 'Alexis', 'Regular', '1', '1', '1', 'Pending', '5', '5');

// Sections Table
// INSERT INTO "public"."section" ("id", "name", "program_id", "year_number", "semester") VALUES ('1', 'C', '1', '1', '1');

// Courses Table
// INSERT INTO "public"."college_course" ("id", "name", "year_number", "code", "semester") VALUES ('1', 'Networking 2', '2', 'NET212', '2'), ('2', 'Advanced Software Development', '3', 'ITProfEL1', '1'), ('3', 'Computer Programming 1', '1', 'CC111', '1'), ('4', 'Computer Programming 2', '1', 'CC112', '2'), ('5', 'Computer Programming 3', '1', 'CC123', '1'), ('6', 'Capstone 1', '3', 'CP111', '2'), ('7', 'Teleportation 1', '4', 'TP111', '1'), ('8', 'Teleportation 2', '4', 'TP222', '2');

// Student Courses Table
// INSERT INTO "public"."student_courses" ("student_id", "course_id", "midterm_grade", "final_grade") VALUES ('1', '1', '5', '3'), ('2', '1', '3', '3'), ('2', '3', '1.5', '1.25');
  Future<List<Course>> fetchCourses() async {
    // First, fetch the student's section details
    final sectionResponse = await supabase
        .from('students')
        .select('section:section_id (id, year_number, semester)')
        .eq('id', widget.studentId)
        .single();

    try {
      final sectionId = sectionResponse['section']['id'];
      final sectionYearNumber =
          sectionResponse['section']['year_number'].toString();
      final sectionSemester =
          sectionResponse['section']['semester'].toString();

      print(
          'Student Section - ID: $sectionId, Year: $sectionYearNumber, Semester: $sectionSemester');

      List<Course> courses = [];

      // Fetch courses for the specific year and semester
      final courseResponse = await supabase
          .from('college_course')
          .select('id, name, code, year_number, semester')
          .eq('year_number', sectionYearNumber)
          .eq('semester', sectionSemester);

      print('Matching Courses: $courseResponse');

      for (var courseData in courseResponse) {
        final courseId = courseData['id'];
        print('Processing Course: $courseData');

        // Check if the course exists in student_courses
        final existingCourseResponse = await supabase
            .from('student_courses')
            .select('''
          course_id, 
          midterm_grade, 
          final_grade, 
          semester,
          year_number,
          college_course:course_id (code, name)
        ''')
            .eq('student_id', widget.studentId)
            .eq('course_id', courseId)
            .maybeSingle();

        Course course;
        if (existingCourseResponse != null) {
          // Course exists in student_courses
          course = Course(
            courseCode:
                existingCourseResponse['college_course']['code'].toString(),
            courseTitle:
                existingCourseResponse['college_course']['name'].toString(),
            midtermGrade: existingCourseResponse['midterm_grade'].toString(),
            finalGrade: existingCourseResponse['final_grade'].toString(),
            yearNumber: existingCourseResponse['year_number'].toString(),
            semester: existingCourseResponse['semester'].toString(),
          );

          courses.add(course);
        } else {
          // Course doesn't exist in student_courses, so insert it
          try {
            final insertResponse =
                await supabase.from('student_courses').insert({
              'student_id': widget.studentId,
              'course_id': courseId,
              'midterm_grade': 5.00,
              'final_grade': 5.00
            }).select('''
              course_id, 
              midterm_grade, 
              final_grade, 
              college_course:course_id (code, name)
            ''').single();

            course = Course(
              courseCode: insertResponse['college_course']['code'].toString(),
              courseTitle: insertResponse['college_course']['name'].toString(),
              midtermGrade: insertResponse['midterm_grade'].toString(),
              finalGrade: insertResponse['final_grade'].toString(),
              semester: insertResponse['semester'].toString(),
              yearNumber: insertResponse['year_number'].toString(),
            );

            courses.add(course);
          } catch (insertError) {
            print('Error inserting course: $insertError');
          }
        }
      }

      print('Courses processed: ${courses.length}');
      return courses;
    } catch (e) {
      debugPrint('Error fetching courses: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color(0xFFF2F8FC),
          child: Column(
            children: [
              // Retain the header
              buildHeader(context),

              // Title of the selected semester
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

              // List of course tiles with course name and grades
              Expanded(
                child: FutureBuilder<List<Course>>(
                  future: futureCourses,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.data == null ||
                        snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No courses found'),
                      );
                    }

                    final courses = snapshot.data!;
                    return ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return CourseTile(
                          courseCode: course.courseCode,
                          courseName: course.courseTitle,
                          midtermGrade: course.midtermGrade,
                          finalGrade: course.finalGrade,
                        );
                      },
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
