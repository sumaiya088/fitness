import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final String title;

  const CategoryPage({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2328),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2328),
        elevation: 0,
        title: Text(title),
      ),
      body: Center(
        child: Text(
          "$title Workouts",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
