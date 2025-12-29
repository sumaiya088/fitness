import 'package:flutter/material.dart';
import 'weight_page.dart';

class GenderPage extends StatefulWidget {
  const GenderPage({super.key});

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  String selectedGender = 'male';

  final Color bgColor = const Color(0xFF1E2328);
  final Color yellow = const Color(0xFFF5C518);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 30),

              /// small subtitle
              const Text(
                'Tell me about yourself',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 8),

              /// title
              const Text(
                "What's your gender?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 50),

              /// MALE
              _genderOption(
                icon: Icons.male,
                value: 'male',
                label: 'Male',
              ),

              const SizedBox(height: 30),

              /// FEMALE
              _genderOption(
                icon: Icons.female,
                value: 'female',
                label: 'Female',
              ),

              const Spacer(),

              /// NEXT BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WeightPage(
                          gender: selectedGender,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'NEXT →',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// gender option widget (icon + label)
  Widget _genderOption({
    required IconData icon,
    required String value,
    required String label,
  }) {
    final bool isSelected = selectedGender == value;

    return GestureDetector(
      onTap: () {
        setState(() => selectedGender = value);
      },
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? yellow : Colors.grey.shade800,
            ),
            child: Icon(
              icon,
              size: 60,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? yellow : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

