import 'dart:async';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isButtonDisabled = false;
  String _buttonText = "Send OTP";
  String _timerText = ""; // Timer text to indicate remaining time
  int _remainingTime = 10; // 10 seconds countdown

  void _sendOtp() {
    // Disable button and start timer for 10 seconds
    setState(() {
      _isButtonDisabled = true;
      _buttonText = "Resend";
      _timerText = "Resend in $_remainingTime s";
    });

    // Start a timer that counts down every second
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 1) {
        setState(() {
          _remainingTime--;
          _timerText = "Resend in $_remainingTime s";
        });
      } else {
        timer.cancel(); // Stop the timer
        setState(() {
          _isButtonDisabled = false;
          _buttonText = "Send OTP";
          _timerText = ""; // Clear the timer text
          _remainingTime = 10; // Reset the remaining time
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FC),
      body: SafeArea(
        child: Column(
          children: [
            buildHeader(), // Header at the very top
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
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
                      child: Column(
                        children: [
                          const SizedBox(height: 20.0),
                          const Center(
                            child: Text(
                              'Forgot Password',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          const Text(
                            'Email Address',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your email address',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: _isButtonDisabled ? null : _sendOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2C9B44),
                                ),
                                child: Text(
                                  _buttonText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // Displaying the timer text
                              if (_timerText.isNotEmpty)
                                Text(
                                  _timerText,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Center(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2C9B44),
                                ),
                                onPressed: () {
                                  // Handle the submit action here
                                },
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                              height: 20.0), // Spacing for the back link
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Go back to login page
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
              ),
            ),
          ],
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
