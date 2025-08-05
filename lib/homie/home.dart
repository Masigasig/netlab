import 'package:flutter/material.dart';
import 'package:netlab/homie/widgets/sidebar.dart'; // Import your custom sidebar

class HomieScreen extends StatefulWidget {
  const HomieScreen({super.key});

  @override
  State<HomieScreen> createState() => _HomieScreenState();
}

class _HomieScreenState extends State<HomieScreen> {
  int selectedIndex = 0;

  final List<String> pages = [
    'Welcome to NetLab!',
    'Let\'s play something!',
    'Your saved items',
    'School dashboard',
    'Open your book!',
  ];

  void _onSidebarTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Row(
        children: [
          Sidebar(
            onItemSelected: _onSidebarTap, // Hook up tap handler
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'NetLab',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Text(
                    pages[selectedIndex],
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
