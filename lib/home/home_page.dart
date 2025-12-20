import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) =>  LoginPage()),
                (_) => false,
              );
            },
          )
        ],
      ),
      body: const Center(child: Text("Logged In")),
    );
  }
}
