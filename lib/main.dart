// Purpose: Main entry point of the app. Initializes Supabase and starts the app.
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'views/welcome_screen.dart';

// Starts the app and connects to Supabase backend.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://jnbpkuptnzpsdxjmatwh.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpuYnBrdXB0bnpwc2R4am1hdHdoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE1Mzk5MzMsImV4cCI6MjA5NzExNTkzM30.kHkIMWpZo0F4AaTB4UmPWxEgOq_RAeOUAe3u1z4cpV4',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  // Builds the main app UI and sets the app theme.
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}
