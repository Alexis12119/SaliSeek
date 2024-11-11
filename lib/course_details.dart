import 'package:SaliSeek/details_page.dart';
import 'package:SaliSeek/semester_tile.dart';
import 'package:flutter/material.dart';

class CourseDetails extends StatelessWidget {
  final String title;

  const CourseDetails({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> tasksAndActivities = List.generate(
      10,
      (index) => {
        'name': 'Task ${index + 1}',
        'description': 'Description of Task ${index + 1}',
        'dueDate': 'Oct. 20'
      },
    );
    final List<Map<String, String>> modules = [
      {'title': 'Module 1', 'url': 'https://google.com'},
      {'title': 'Module 2', 'url': 'https://google.com'},
      {'title': 'Module 3', 'url': 'https://google.com'},
      // Add more modules with their URLs...
    ];

    Widget buildSectionWithArrows({
      required ScrollController scrollController,
      required List<Map<String, String>> items,
    }) {
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
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return SemesterTile(
                        items[index]['title']!,
                        url: items[index]['url'],
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
            ),
            Expanded(child: buildTasksAndActivities()),
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
