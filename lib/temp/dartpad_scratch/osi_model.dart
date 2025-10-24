// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

void main() {
  runApp(const ProviderScope(child: OSIModelApp()));
}

// Riverpod provider for the layer stack
final layerStackProvider =
    StateNotifierProvider<LayerStackNotifier, List<Map<String, String>>>((ref) {
      return LayerStackNotifier();
    });

class LayerStackNotifier extends StateNotifier<List<Map<String, String>>> {
  LayerStackNotifier()
    : super([
        {
          'name': 'Application',
          'description': 'End user layer (HTTP, FTP, SMTP)',
          'color': '0xFFE91E63',
          'data': 'GET /index.html HTTP/1.1',
        },
        {
          'name': 'Presentation',
          'description': 'Syntax layer (SSL, SSH, IMAP)',
          'color': '0xFF9C27B0',
          'data': 'Encrypted: TLS 1.3',
        },
        {
          'name': 'Session',
          'description': 'Synch & send to port (APIs, Sockets)',
          'color': '0xFF673AB7',
          'data': 'Session ID: 4a2f8c9b',
        },
        {
          'name': 'Transport',
          'description': 'End-to-end connections (TCP, UDP)',
          'color': '0xFF3F51B5',
          'data': 'Port: 443 → 8080',
        },
        {
          'name': 'Network',
          'description': 'Packets (IP, ICMP, IPSec)',
          'color': '0xFF2196F3',
          'data': 'From: 192.168.1.10 → To: 172.16.0.5',
        },
        {
          'name': 'Data Link',
          'description': 'Frames (Ethernet, PPP, Switch)',
          'color': '0xFF03A9F4',
          'data': 'MAC: A1:B2:C3:D4:E5:F6 → 1A:2B:3C:4D:5E:6F',
        },
        {
          'name': 'Physical',
          'description': 'Physical structure (Coax, Fiber, Hubs)',
          'color': '0xFF00BCD4',
          'data': '10101100 11010010 10110011 01001110',
        },
      ]);

  final List<Map<String, String>> allLayers = [
    {
      'name': 'Application',
      'description': 'End user layer (HTTP, FTP, SMTP)',
      'color': '0xFFE91E63',
      'data': 'GET /index.html HTTP/1.1',
    },
    {
      'name': 'Presentation',
      'description': 'Syntax layer (SSL, SSH, IMAP)',
      'color': '0xFF9C27B0',
      'data': 'Encrypted: TLS 1.3',
    },
    {
      'name': 'Session',
      'description': 'Synch & send to port (APIs, Sockets)',
      'color': '0xFF673AB7',
      'data': 'Session ID: 4a2f8c9b',
    },
    {
      'name': 'Transport',
      'description': 'End-to-end connections (TCP, UDP)',
      'color': '0xFF3F51B5',
      'data': 'Port: 443 → 8080',
    },
    {
      'name': 'Network',
      'description': 'Packets (IP, ICMP, IPSec)',
      'color': '0xFF2196F3',
      'data': 'From: 192.168.1.10 → To: 172.16.0.5',
    },
    {
      'name': 'Data Link',
      'description': 'Frames (Ethernet, PPP, Switch)',
      'color': '0xFF03A9F4',
      'data': 'MAC: A1:B2:C3:D4:E5:F6 → 1A:2B:3C:4D:5E:6F',
    },
    {
      'name': 'Physical',
      'description': 'Physical structure (Coax, Fiber, Hubs)',
      'color': '0xFF00BCD4',
      'data': '10101100 11010010 10110011 01001110',
    },
  ];

  void pushLayer() {
    if (state.length < allLayers.length) {
      state = [...state, allLayers[state.length]];
    }
  }

  void popLayer() {
    if (state.isNotEmpty) {
      state = state.sublist(0, state.length - 1);
    }
  }

  void reset() {
    state = List.from(allLayers);
  }
}

class OSIModelApp extends StatelessWidget {
  const OSIModelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OSI Model Stack',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const OSIStackScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class OSIStackScreen extends ConsumerWidget {
  const OSIStackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layerStack = ref.watch(layerStackProvider);
    final notifier = ref.read(layerStackProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('OSI Model Stack Visualizer'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'OSI Model Layers',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${layerStack.length} of 7 layers',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 24),
                        // Layered stack visualization - Physical at bottom, Application at top
                        SizedBox(
                          height: 500,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: List.generate(layerStack.length, (index) {
                              // Reverse to show Physical (L7) at bottom
                              final reversedIndex =
                                  layerStack.length - 1 - index;
                              final layer = layerStack[reversedIndex];
                              final color = Color(int.parse(layer['color']!));

                              // Check if layer is "locked" (L1-L4 are not implemented yet)
                              final isLocked =
                                  reversedIndex < 4; // L1, L2, L3, L4
                              final displayColor = isLocked
                                  ? Colors.grey
                                  : color;

                              // Calculate height and width - bottom layer is tallest and widest
                              final layerHeight = 450.0 - (index * 60.0);
                              final horizontalPadding = index * 8.0;

                              return Positioned(
                                bottom: 0,
                                left: horizontalPadding,
                                right: horizontalPadding,
                                child: Container(
                                  height: layerHeight,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        displayColor,
                                        displayColor.withOpacity(0.85),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: displayColor.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, -2),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.25,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                'L${reversedIndex + 1}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                layer['name']!,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            if (isLocked)
                                              Icon(
                                                Icons.lock,
                                                color: Colors.white.withOpacity(
                                                  0.7,
                                                ),
                                                size: 14,
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          layer['description']!,
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.85,
                                            ),
                                            fontSize: 10,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        if (!isLocked)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(
                                                0.2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              layer['data']!,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontFamily: 'monospace',
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        else
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              'Not implemented yet',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.5,
                                                ),
                                                fontSize: 9,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: layerStack.isEmpty ? null : notifier.popLayer,
                      icon: const Icon(Icons.remove),
                      label: const Text('Pop Layer'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: layerStack.length >= 7
                          ? null
                          : notifier.pushLayer,
                      icon: const Icon(Icons.add),
                      label: const Text('Push Layer'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: notifier.reset,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
