import 'package:SaliSeek/submitted_file.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Tasks Table
// INSERT INTO "public"."tasks" ("id", "due_date", "description", "url", "student_id", "course_id", "drive", "youtube", "file", "status", "grade", "date_passed") VALUES ('1', '2024-11-23', 'This is the description', 'jiro', '2', '3', null, null, null, '', '', '2024-11-22'), ('2', '2024-11-30', 'This is the second description', 'haha', '2', '4', null, null, null, '', '', '2024-11-26'), ('3', '2024-11-21', 'This is the description', 'google.com', '2', '9', null, null, null, '', '', '2024-11-20'), ('4', '2024-11-30', 'Bad Description', 'sir hensonn beke nemen', '5', '3', null, null, null, '', '', '2024-11-27');
class DetailsPage extends StatefulWidget {
  final int taskId;
  const DetailsPage({super.key, required this.taskId});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  List<SubmittedFile> submittedFiles = [];
  final supabase = Supabase.instance.client;

  String? dueDate;
  String? description;
  String? activityLink;
  TextEditingController urlController = TextEditingController();
  bool isPastDueDate = false; // Flag for due date check

  @override
  void initState() {
    super.initState();
    fetchTaskData();
  }

  Future<void> fetchTaskData() async {
    final response = await supabase
        .from('tasks')
        .select('due_date, description, url')
        .eq('id', widget.taskId)
        .single();
    print(response);

    setState(() {
      dueDate = response['due_date'];
      description = response['description'];
      activityLink = response['url'];
      urlController.text = activityLink ?? '';

      if (dueDate != null) {
        final parsedDueDate = DateTime.parse(dueDate!);
        isPastDueDate = DateTime.now().isAfter(parsedDueDate);
      }
    });
  }

Future<void> _updateURL() async {
  final newUrl = urlController.text;
  if (newUrl.isNotEmpty) {
    // Get the current timestamp
    final submissionDate = DateTime.now().toIso8601String();

    // Update the database with the new URL and submission date
    await supabase
        .from('tasks')
        .update({'url': newUrl, 'date_passed': submissionDate}).eq('id', widget.taskId);

    setState(() {
      activityLink = newUrl;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('URL updated successfully!'),
          backgroundColor: Color(0xFF2C9B44),
        ),
      );
    }
  }
}

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
                      Text(
                        'Due Date: ${dueDate ?? "Loading..."}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      const SizedBox(height: 16.0),
                      if (isPastDueDate)
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
                                  'The submission period has ended. You can no longer submit a URL.',
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
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        description ?? 'Loading...',
                        style: const TextStyle(fontSize: 14.0),
                      ),
                      const SizedBox(height: 24.0),
                      const Text(
                        'Set Your Activity Submission URL:',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      GestureDetector(
                        onTap: isPastDueDate
                            ? null
                            : () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                        child: AbsorbPointer(
                          absorbing: isPastDueDate,
                          child: TextField(
                            controller: urlController,
                            decoration: InputDecoration(
                              hintText: isPastDueDate
                                  ? 'Submission closed (Past due date)'
                                  : 'Enter your URL here',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isPastDueDate ? null : _updateURL,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isPastDueDate ? Colors.red : const Color(0xFF2C9B44),
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            isPastDueDate ? 'Submission Closed' : 'Submit URL',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: isPastDueDate ? Colors.red : const Color(0xFFF2F8FC),
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
        ],
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
