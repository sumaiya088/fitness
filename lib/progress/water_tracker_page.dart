import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/water_glass.dart';

class WaterPage extends StatefulWidget {
  const WaterPage({super.key});

  @override
  State<WaterPage> createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterPage> {
  static const int targetMl = 2500;
  final SupabaseClient _client = Supabase.instance.client;

  late String userId;
  late String today;
  int waterMl = 0;

  final List<Map<String, String>> todayLogs = [];

  // ================= INIT =================

  @override
  void initState() {
    super.initState();
    userId = _client.auth.currentUser!.id;
    today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    _ensureTodayRow().then((_) => _loadTodayWater());
  }

  // ================= SUPABASE =================

  Future<void> _ensureTodayRow() async {
    final data = await _client
        .from('daily_progress')
        .select()
        .eq('user_id', userId)
        .eq('created_at', today)
        .maybeSingle();

    if (data == null) {
      await _client.from('daily_progress').insert({
        'user_id': userId,
        'steps': 0,
        'water_ml': 0,
        'calories': 0,
        'created_at': today,
      });
    }
  }

  Future<void> _loadTodayWater() async {
    final data = await _client
        .from('daily_progress')
        .select('water_ml')
        .eq('user_id', userId)
        .eq('created_at', today)
        .maybeSingle();

    if (data != null) {
      setState(() {
        waterMl = data['water_ml'] ?? 0;
      });
    }
  }

  Future<void> _addWater(int amount) async {
    final newValue = waterMl + amount;

    await _client
        .from('daily_progress')
        .update({'water_ml': newValue})
        .eq('user_id', userId)
        .eq('created_at', today);

    setState(() {
      waterMl = newValue;
      todayLogs.insert(0, {
        'amount': '${amount}ml',
        'time': DateFormat('HH:mm').format(DateTime.now()),
      });
    });
  }

  // ================= LOGIC =================

  String hydrationStatus() {
    if (waterMl < 800) return "Low";
    if (waterMl < 1500) return "Moderate";
    return "Good";
  }

  String athletePerformance() {
    if (waterMl < 800) return "-60%";
    if (waterMl < 1500) return "-30%";
    return "+10%";
  }

  String energyLevel() {
    if (waterMl < 800) return "-50%";
    if (waterMl < 1500) return "-20%";
    return "+15%";
  }

  String hydrationTipText() {
    if (waterMl < 800) {
      return "You are dehydrated. Drink water immediately!";
    }
    if (waterMl < 1500) {
      return "Keep drinking. You are halfway there.";
    }
    return "Great job! You are well hydrated today 💧";
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    final double level = (waterMl / targetMl).clamp(0, 1);
    final int percent =
        ((waterMl / targetMl) * 100).clamp(0, 100).toInt();

    return Scaffold(
      backgroundColor: const Color(0xFF1F2A30),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2A30),
        elevation: 0,
        title: const Text(
          "Drink Water Glass",
          style: TextStyle(color: Colors.amber),
        ),
        iconTheme: const IconThemeData(color: Colors.amber),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // ================= GLASS =================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F2A44),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // RULER
                  SizedBox(
                    height: 220,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        8,
                        (i) => Row(
                          children: [
                            Text("${8 - i}",
                                style: const TextStyle(
                                    color: Colors.amber, fontSize: 12)),
                            const SizedBox(width: 6),
                            Container(width: 14, height: 2, color: Colors.amber),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // GLASS
                  SizedBox(
                    height: 260,
                    width: 160,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        WaterGlass(level: level),
                        Positioned(
                          bottom: 0,
                          child: Image.asset(
                            "assets/images/glass.png",
                            width: 150,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  Column(
                    children: [
                      const Icon(Icons.water_drop, color: Colors.white),
                      const SizedBox(height: 6),
                      Text(
                        "$waterMl / $targetMl ml",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ================= DATE & STATUS =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFC14D),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  const Text("Date & Time",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(DateFormat("dd MMM yyyy • HH:mm")
                      .format(DateTime.now())),
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text("Status: ${hydrationStatus()}"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= PROGRESS =================
            Row(
              children: [
                _circularGoal(percent),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    children: [
                      _infoCard("Athlete Performance", athletePerformance()),
                      const SizedBox(height: 8),
                      _infoCard("Energy Level", energyLevel()),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ================= QUICK ADD =================
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "+ Quick Add Water",
                style: TextStyle(color: Colors.white.withOpacity(0.8)),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _quickBtn("100ml", () => _addWater(100)),
                _quickBtn("250ml", () => _addWater(250)),
                _quickBtn("350ml", () => _addWater(350)),
                _quickBtn("500ml", () => _addWater(500)),
              ],
            ),

            // ================= TODAY LOG =================
            if (todayLogs.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF253B4A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Today's Water Log",
                        style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    ...todayLogs.map(
                      (log) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.water_drop,
                                color: Colors.white, size: 16),
                            Text(log['amount']!,
                                style: const TextStyle(color: Colors.white)),
                            Text(log['time']!,
                                style:
                                    const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 12),

            // ================= HYDRATION ALERT (ALWAYS) =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF3A2738),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Hydration Alert!",
                      style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    hydrationTipText(),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.amber,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Progress"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // ================= WIDGETS =================

  Widget _circularGoal(int percent) {
    return SizedBox(
      height: 190,
      width: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: percent / 100,
            strokeWidth: 18,
            backgroundColor: const Color(0xFF253B4A),
            valueColor:
                const AlwaysStoppedAnimation(Color(0xFF4FC3F7)),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("$percent%",
                  style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber)),
              const Text("Daily Goal",
                  style:
                      TextStyle(color: Colors.white70, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value, style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }

  Widget _quickBtn(String text, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade200,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(text),
    );
  }
}

