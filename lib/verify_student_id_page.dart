import 'package:SaliSeek/login_page.dart';
import 'package:SaliSeek/sign_up_page.dart';
import 'package:flutter/material.dart';

class VerifyStudentIdPage extends StatefulWidget {
  const VerifyStudentIdPage({super.key});

  @override
  State<VerifyStudentIdPage> createState() => _VerifyStudentIdPageState();
}

class _VerifyStudentIdPageState extends State<VerifyStudentIdPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _studentIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildHeader(),
                Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'Verify Student ID',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          const Text(
                            'Student ID',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4.0),
                          TextFormField(
                            controller: _studentIdController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your Student ID',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Student ID';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          Center(
                            child: SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2C9B44),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // If validated, navigate to SignUpPage
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignUpPage()),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Verify',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFFF2F8FC),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginPage()),
                                );
                              },
                              child: const Text(
                                'Back to Login',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 600 ? 10.0 : 18.0;
    double subtitleFontSize = screenWidth < 600 ? 9.0 : 12.0;
    double padding = screenWidth < 600 ? 12.0 : 16.0;
    double avatarSize = screenWidth < 600 ? 25.0 : 30.0;
    double spacing = screenWidth < 600 ? 12.0 : 16.0;

    return Container(
      color: const Color(0xFFF2F8FC),
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          CircleAvatar(
            radius: avatarSize,
            backgroundColor: const Color(0xFFF2F8FC),
            child: const Icon(Icons.school, size: 30, color: Colors.green),
          ),
          SizedBox(width: spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pamantasan ng Lungsod ng San Pablo',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Brgy. San Jose, San Pablo City',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Tel No: (049) 536-7380',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Email Address: plspofficial@plsp.edu.ph',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.black,
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
