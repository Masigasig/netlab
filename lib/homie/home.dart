import 'package:flutter/material.dart';
import 'package:netlab/homie/widgets/dashboard.dart';
import 'package:netlab/homie/widgets/sidebar.dart';
import 'package:netlab/homie/widgets/simulator.dart';
import 'package:netlab/homie/widgets/study_section/study.dart';
import 'package:netlab/homie/widgets/tutorial.dart';

class HomieScreen extends StatefulWidget {
  const HomieScreen({super.key});

  @override
  State<HomieScreen> createState() => _HomieScreenState();
}

class _HomieScreenState extends State<HomieScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    const DashboardScreen(),
    const SimulatorScreen(),
    const TutorialScreen(),
    const StudyScreen(),
  ];

  void _onSidebarTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Row(
        children: [
          Sidebar(
            onItemSelected: _onSidebarTap,
          ),
          Expanded(
            child: pages[selectedIndex],
          ),
        ],
      ),
    );
  }
}