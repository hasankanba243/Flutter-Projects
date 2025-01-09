import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wallpaper/loginPage.dart';


import 'firebase_options.dart';
import 'main.dart';
import 'main.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://jxypdbfebtmtndlvkfsh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp4eXBkYmZlYnRtdG5kbHZrZnNoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU5MTAyMjEsImV4cCI6MjA1MTQ4NjIyMX0.J1XpPMPuQF2gQkXO4h4bF9Uh5vMW8RfnO8p4Rh8I3Bc',
  );
  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Walls By Node',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurpleAccent,
          centerTitle: true,
          titleTextStyle: GoogleFonts.bebasNeue(fontSize: 30),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: loginPage(),
    );
  }
}
