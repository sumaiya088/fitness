import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rmtikqdemzsgnoefxwvh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJtdGlrcWRlbXpzZ25vZWZ4d3ZoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjYxNTgwMTYsImV4cCI6MjA4MTczNDAxNn0.ATpf84jCpioTzqLc-uV9heSUYJUTTXEao2AfcxVDgUM',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}




