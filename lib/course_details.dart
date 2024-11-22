import 'package:SaliSeek/details_page.dart';
import 'package:SaliSeek/module_tile.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

// Modules Table
// INSERT INTO "public"."modules" ("id", "name", "course_id", "url") VALUES ('1', 'Module 1(ITProfEL2)', '2', 'https://google.com'), ('2', 'Module 1(CC111)', '3', 'https://google.com');

// Tasks Table
// INSERT INTO "public"."tasks" ("id", "due_date", "description", "url", "student_id", "course_id") VALUES ('1', '2024-11-23', 'This is the description', null, '2', '3');

// Students Table
// INSERT INTO "public"."students" ("id", "email", "password", "last_name", "type", "section_id", "program_id", "department_id", "grade_status") VALUES ('1', 'test@gmail.com', 'test123', 'Test', 'Regular', '2', '1', '1', 'Pending'), ('2', 'corporal461@gmail.com', 'Alexis-121', 'Alexis', 'Regular', '1', '1', '1', 'Pending');

// Student Courses Table
// INSERT INTO "public"."student_courses" ("student_id", "course_id", "midterm_grade", "final_grade", "year_number", "semester") VALUES ('2', '3', '5', '5', '1', '1');

// College Course Table
// INSERT INTO "public"."college_course" ("id", "name", "year_number", "code", "semester") VALUES ('1', 'Networking 2', '2', 'NET212', '2'), ('2', 'Advanced Software Development', '3', 'ITProfEL1', '1'), ('3', 'Computer Programming 1', '1', 'CC111', '1'), ('4', 'Computer Programming 2', '1', 'CC112', '2'), ('5', 'Computer Programming 3', '2', 'CC123', '1'), ('6', 'Capstone 1', '3', 'CP111', '2'), ('7', 'Teleportation 1', '4', 'TP111', '1'), ('8', 'Teleportation 2', '4', 'TP222', '2'), ('9', 'Living in the IT Era', '1', 'LITE', '1');

// Teachers Table
// INSERT INTO "public"."teacher" ("id", "first_name", "email", "password", "last_name") VALUES ('1', 'Hensonn', 'henz@gmail.com', 'admin', 'Palomado'), ('2', 'Audrey', 'audrey@gmail.com', 'audrey123', 'Alinea'), ('3', 'Austhin', 'aus@gmail.com', 'aus123', 'Sabater');

// Teacher Courses Table
// INSERT INTO "public"."teacher_courses" ("id", "teacher_id", "course_id") VALUES ('1', '3', '9'), ('2', '1', '2'), ('3', '2', '3');
class CourseDetails extends StatelessWidget {
  final String title;
  final String studentId;
  final String courseId;

  CourseDetails(
      {super.key,
      required this.title,
      required this.studentId,
      required this.courseId});

  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchTasks() async {
    try {
      final response = await supabase
          .from('tasks')
          .select(
              'id, due_date, description, student_id, students(first_name,last_name)')
          .eq('course_id', courseId)
          .order('due_date', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching tasks: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> fetchInstructor() async {
    try {
      final response = await supabase
          .from('teacher_courses')
          .select('teacher:teacher_id(first_name, last_name)')
          .eq('course_id', courseId)
          .single();

      return response['teacher'];
    } catch (e) {
      debugPrint('Error fetching instructor: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchModules() async {
    try {
      final response =
          await supabase.from('modules').select('*').eq('course_id', courseId);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching modules: $e');
      return [];
    }
  }

  Widget buildSectionWithArrows({
    required ScrollController scrollController,
  }) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchModules(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No modules available'));
        }

        final modules = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: modules.length,
                      itemBuilder: (context, index) {
                        final module = modules[index];
                        return ModuleTile(
                          module['name'],
                          url: module['url'],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                FutureBuilder<Map<String, dynamic>?>(
                  future: fetchInstructor(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        'Loading...',
                        style: TextStyle(fontSize: 18.0),
                      );
                    }

                    if (snapshot.hasError || snapshot.data == null) {
                      return const Text(
                        'Instructor: Unknown',
                        style: TextStyle(fontSize: 18.0),
                      );
                    }

                    final instructor = snapshot.data!;
                    final fullName =
                        '${instructor['first_name']} ${instructor['last_name']}';

                    return Text(
                      'Instructor: $fullName',
                      style: const TextStyle(fontSize: 18.0),
                    );
                  },
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
            ),
            Expanded(child: buildTasksAndActivities()),
          ],
        ),
      ),
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
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchTasks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No tasks available'));
                  }

                  final tasks = snapshot.data!;

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      final dueDate = DateTime.parse(task['due_date']);
                      final formattedDate =
                          DateFormat('MMM. dd').format(dueDate);
                      final studentName = task['students']['first_name'] +
                              ' ' +
                              task['students']['last_name'] ??
                          'Unknown';

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
                                Text(
                                  studentName,
                                  style: const TextStyle(fontSize: 14.0),
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Due ($formattedDate)',
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              task['description'],
                              style: const TextStyle(fontSize: 14.0),
                            ),
                            const SizedBox(height: 16.0),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          DetailsPage(taskId: task['id']),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return FadeTransition(
                                            opacity: animation, child: child);
                                      },
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 600 ? 10.0 : 18.0;
    double subtitleFontSize =
        screenWidth < 600 ? 9.0 : 12.0; // Subtitle font size
    double padding = screenWidth < 600 ? 12.0 : 16.0;
    double iconSize = screenWidth < 600 ? 15.0 : 20.0;
    double iconPadding = screenWidth < 600 ? 0.0 : 8.0;
    double logoSize = screenWidth < 600 ? 20.0 : 30.0;

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
            backgroundImage: const AssetImage('assets/images/plsp.jpg'),
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
