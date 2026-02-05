import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/login_page.dart';
import '../home/home_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final supabase = Supabase.instance.client;

  final List<String> stickers = [
    'https://api.dicebear.com/7.x/avataaars/png?seed=A',
    'https://api.dicebear.com/7.x/avataaars/png?seed=B',
    'https://api.dicebear.com/7.x/avataaars/png?seed=C',
    'https://api.dicebear.com/7.x/avataaars/png?seed=D',
  ];

  String selectedSticker =
      'https://api.dicebear.com/7.x/avataaars/png?seed=A';

  Future<void> handleLogout() async {
    await supabase.auth.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  String getUserName() {
    final email = supabase.auth.currentUser?.email ?? "User";
    return email.split('@')[0].toUpperCase();
  }

  void showPersonalInfo() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2F35),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Personal Info",
              style: TextStyle(
                color: Color(0xFFF5C518),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _infoRow("Name", getUserName()),
            _infoRow(
                "Email", supabase.auth.currentUser?.email ?? ""),
            _infoRow("Status", "Active"),
          ],
        ),
      ),
    );
  }

  void showSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2F35),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "Settings",
              style: TextStyle(
                color: Color(0xFFF5C518),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text("App Version: 1.0.1",
                style: TextStyle(color: Colors.white)),
            SizedBox(height: 10),
            Text("Up to date",
                style: TextStyle(color: Colors.white24)),
          ],
        ),
      ),
    );
  }

  static Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white54)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color bg = Color(0xFF1E2328);
    const Color yellow = Color(0xFFF5C518);

    return Scaffold(
      backgroundColor: bg,

      // ✅ SAME BOTTOM BAR AS HOME
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: bg,
        currentIndex: 1, // Profile active
        selectedItemColor: yellow,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                "Profile",
                style: TextStyle(
                  color: yellow,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // PROFILE AVATAR
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: yellow.withOpacity(0.15),
                          blurRadius: 30,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 65,
                    backgroundColor: yellow,
                    child: CircleAvatar(
                      radius: 62,
                      backgroundColor:
                          const Color(0xFF2A2F35),
                      backgroundImage:
                          NetworkImage(selectedSticker),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Text(
                getUserName(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Choose your sticker",
                style:
                    TextStyle(color: Colors.white38, fontSize: 12),
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: stickers.map((url) {
                  final isSelected = selectedSticker == url;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => selectedSticker = url),
                    child: Container(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? yellow
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(url),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),

              _profileMenu(Icons.person_outline,
                  "Personal Info", showPersonalInfo),
              _profileMenu(
                  Icons.settings_outlined, "Settings", showSettings),

              const SizedBox(height: 50),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: handleLogout,
                    child: const Text(
                      "Log Out",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileMenu(
      IconData icon, String title, VoidCallback action) {
    return GestureDetector(
      onTap: action,
      child: Container(
        margin:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFF5C518)),
            const SizedBox(width: 20),
            Text(title,
                style:
                    const TextStyle(color: Colors.white, fontSize: 16)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios,
                color: Colors.white24, size: 14),
          ],
        ),
      ),
    );
  }
}

