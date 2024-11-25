// Week Table
// INSERT INTO "public"."week" ("id", "name") VALUES ('1', 'Week 1'), ('2', 'Week 2'), ('3', 'Week 3'), ('4', 'Week 4'), ('5', 'Week 5'), ('6', 'Week 6'), ('7', 'Week 7'), ('8', 'Week 8'), ('9', 'Week 9');
// Modules Table
// INSERT INTO "public"."modules" ("id", "name", "course_id", "url", "teacher_id", "week") VALUES ('1', 'Module 1', '9', 'https://google.com', null, null), ('2', 'Module 1', '3', 'https://google.com', '2', '1'), ('3', 'Module 2', '3', 'www.google.com', '2', '1'), ('4', 'Module 3', '3', 'www.google.com', '2', '1');

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
import 'package:SaliSeek/details_page.dart';
import 'package:SaliSeek/module_tile.dart';
import 'package:SaliSeek/week_modules_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class CourseDetails extends StatefulWidget {
  final String title;
  final String studentId;
  final String courseId;

  const CourseDetails({
    super.key,
    required this.title,
    required this.studentId,
    required this.courseId,
  });

  @override
  CourseDetailsState createState() => CourseDetailsState();
}

class CourseDetailsState extends State<CourseDetails> {
  final supabase = Supabase.instance.client;
  final ScrollController moduleScrollController = ScrollController();
  final List<RealtimeChannel> _subscriptions = [];

  // State variables
  List<Map<String, dynamic>>? _tasks;
  List<Map<String, dynamic>>? _modules;
  Map<String, dynamic>? _teacher;
  final Map<String, List<Map<String, dynamic>>> _weekModules = {};
  // Loading state flags
  bool _isLoadingTasks = true;
  bool _isLoadingModules = true;
  bool _isLoadingTeacher = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _setupRealtimeSubscriptions();
  }

  Future<void> _loadInitialData() async {
    // Load all data in parallel
    await Future.wait([
      fetchTasks(),
      fetchModules(),
      fetchInstructor(),
    ]);
  }

  @override
  void dispose() {
    for (var subscription in _subscriptions) {
      subscription.unsubscribe();
    }
    moduleScrollController.dispose();
    super.dispose();
  }

  void _setupRealtimeSubscriptions() {
    final teacherCoursesChannel = supabase
        .channel('teacher_courses_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'teacher',
          callback: (payload) => fetchInstructor(),
        )
        .subscribe();

    final tasksChannel = supabase
        .channel('tasks_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'tasks',
          callback: (payload) => fetchTasks(),
        )
        .subscribe();

    final modulesChannel = supabase
        .channel('modules_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'modules',
          callback: (payload) => fetchModules(),
        )
        .subscribe();

    _subscriptions
        .addAll([teacherCoursesChannel, tasksChannel, modulesChannel]);
  }

  Future<void> fetchTasks() async {
    if (!mounted) return;

    setState(() => _isLoadingTasks = true);
    try {
      final response = await supabase
          .from('tasks')
          .select(
              'id, due_date, description, student_id, students(first_name,last_name)')
          .eq('course_id', widget.courseId)
          .order('due_date', ascending: true);

      if (mounted) {
        setState(() {
          _tasks = List<Map<String, dynamic>>.from(response);
          _isLoadingTasks = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching tasks: $e');
      if (mounted) {
        setState(() => _isLoadingTasks = false);
      }
    }
  }

  Future<void> fetchInstructor() async {
    if (!mounted) return;

    setState(() => _isLoadingTeacher = true);
    try {
      final response = await supabase
          .from('teacher_courses')
          .select('teacher:teacher_id(first_name, last_name)')
          .eq('course_id', widget.courseId)
          .maybeSingle();

      if (mounted) {
        setState(() {
          _teacher = response?['teacher'];
          _isLoadingTeacher = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching instructor: $e');
      if (mounted) {
        setState(() => _isLoadingTeacher = false);
      }
    }
  }

  Widget buildModulesSection() {
    if (_isLoadingModules) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_modules == null || _modules!.isEmpty) {
      return const Center(child: Text('No modules available'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 100,
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: moduleScrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: _modules!.length,
                  itemBuilder: (context, index) {
                    final module = _modules![index];
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
  }

  Widget buildInstructorSection() {
    if (_isLoadingTeacher) {
      return const Text(
        'Loading...',
        style: TextStyle(fontSize: 18.0),
      );
    }

    if (_teacher == null) {
      return const Text(
        'Instructor: Unknown',
        style: TextStyle(fontSize: 18.0),
      );
    }

    final fullName = '${_teacher!['first_name']} ${_teacher!['last_name']}';
    return Text(
      'Instructor: $fullName',
      style: const TextStyle(fontSize: 18.0),
    );
  }

  Widget buildTasksSection() {
    if (_isLoadingTasks) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_tasks == null || _tasks!.isEmpty) {
      return const Center(child: Text('No tasks available'));
    }

    return ListView.builder(
      itemCount: _tasks!.length,
      itemBuilder: (context, index) {
        final task = _tasks![index];
        final dueDate = DateTime.parse(task['due_date']);
        final formattedDate = DateFormat('MMM. dd').format(dueDate);
        final studentName =
            '${task['students']['first_name']} ${task['students']['last_name']}';

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
                    child: const Icon(Icons.person, color: Colors.green),
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
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            DetailsPage(taskId: task['id']),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
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
  }

  Future<void> fetchModules() async {
    if (!mounted) return;

    setState(() => _isLoadingModules = true);
    try {
      final response = await supabase
          .from('modules')
          .select('*, week:week(id, name)')
          .eq('course_id', widget.courseId)
          .order('week');

      if (mounted) {
        setState(() {
          _modules = List<Map<String, dynamic>>.from(response);
          _organizeModulesByWeek();
          _isLoadingModules = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching modules: $e');
      if (mounted) {
        setState(() => _isLoadingModules = false);
      }
    }
  }

  void _organizeModulesByWeek() {
    _weekModules.clear();
    for (var module in _modules ?? []) {
      if (module['week'] != null) {
        final weekId = module['week']['id'].toString();
        _weekModules.putIfAbsent(weekId, () => []);
        _weekModules[weekId]!.add(module);
      }
    }
  }

  Widget buildWeeksSection() {
    if (_isLoadingModules) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_weekModules.isEmpty) {
      return const Center(child: Text('No modules available'));
    }

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _weekModules.length,
        itemBuilder: (context, index) {
          final weekId = _weekModules.keys.elementAt(index);
          final modules = _weekModules[weekId]!;
          final weekName = modules.first['week']['name'];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeekModulesPage(
                      weekName: weekName,
                      modules: modules,
                    ),
                  ),
                );
              },
              child: Container(
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.green),
                    const SizedBox(height: 8),
                    Text(
                      weekName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${modules.length} modules',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FC),
      body: SafeArea(
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
                buildInstructorSection(),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 0.0),
              child: Text(
                'Weekly Materials:',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16.0),
            buildWeeksSection(),
            Expanded(
              child: Container(
                color: const Color(0xFFF2F8FC),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tasks and Activities:',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Expanded(child: buildTasksSection()),
                    ],
                  ),
                ),
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


