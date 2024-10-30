import 'package:flutter/material.dart';

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
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

