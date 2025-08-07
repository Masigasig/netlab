import 'package:flutter/material.dart';

class SimulatorScreen extends StatelessWidget {
  const SimulatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 64.0),
      color: const Color(0xFF121212),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            const Text(
              'Network Simulator',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // Description
            Container(
              constraints: const BoxConstraints(maxWidth: 800),
              child: const Text(
                'Experience hands-on network configuration and troubleshooting in a safe, virtual environment. Build, test, and understand network topologies with our interactive simulator.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Feature Grid
            Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFeatureCard(
                    icon: Icons.device_hub,
                    title: 'Network Devices',
                    description: 'Routers, switches, and endpoints with real-world configurations',
                  ),
                  const SizedBox(width: 24),
                  _buildFeatureCard(
                    icon: Icons.cable,
                    title: 'Live Connections',
                    description: 'Create and test network connections in real-time',
                  ),
                  const SizedBox(width: 24),
                  _buildFeatureCard(
                    icon: Icons.bug_report,
                    title: 'Troubleshooting',
                    description: 'Debug network issues with built-in diagnostic tools',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 64),

            // Start Button
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to simulator
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Start Simulation',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
