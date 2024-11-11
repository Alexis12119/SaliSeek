// import 'package:SaliSeek/login_page.dart';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: LoginPage(),
//     );
//   }
// }

import 'package:SaliSeek/login_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://eqaqizznngarxghlrpul.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxYXFpenpubmdhcnhnaGxycHVsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzAyODk5MzgsImV4cCI6MjA0NTg2NTkzOH0.gCKoYLBnY0em8c0WnaWFCdukjgMvWiOmZgGzIstb8Kk',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'SaliSeek',
      home: LoginPage(),
    );
  }
}
