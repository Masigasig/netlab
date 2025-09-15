import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SimulationScreen extends ConsumerStatefulWidget {
  const SimulationScreen({super.key});

  @override
  ConsumerState<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends ConsumerState<SimulationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simulation')),
      body: const Center(child: Text('Simulation Screen')),
    );
  }
}
