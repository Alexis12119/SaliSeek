import 'package:flutter/material.dart';

class CourseTile extends StatelessWidget {
  final String courseCode;
  final String courseName;
  final String midtermGrade;

  const CourseTile({
    super.key,
    required this.courseCode,
    required this.courseName,
    required this.midtermGrade,
  });


  String formatGrade(String grade) {
    // If the grade is already in the desired format, return it
    if (grade.contains('.')) {
      // If it's already a decimal like 1.25, keep it as is
      if (grade.split('.')[1].length > 2) return grade;
      
      // If it's a whole number or has one decimal place, format to two decimal places
      return double.parse(grade).toStringAsFixed(2);
    }
    
    // If it's a whole number, convert to two decimal places
    return double.parse(grade).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Adjust font sizes and padding for different screen widths
    double fontSize = screenWidth < 600 ? 14.0 : 18.0;
    double gradeFontSize = screenWidth < 600 ? 12.0 : 16.0;
    double padding = screenWidth < 600 ? 8.0 : 16.0;
    double tilesPadding = screenWidth < 600 ? 16.0 : 26.0;
    double gradeSpacing = screenWidth < 600 ? 16.0 : 24.0;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(tilesPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Course Code and Name on the left
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courseCode,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(courseName, style: TextStyle(fontSize: fontSize - 2)),
                ],
              ),
              // Grades on the right
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        formatGrade(midtermGrade),
                        style: TextStyle(
                          fontSize: gradeFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: gradeSpacing),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Midterm',
                        style: TextStyle(fontSize: gradeFontSize - 2),
                      ),
                      SizedBox(width: gradeSpacing - 4),
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
