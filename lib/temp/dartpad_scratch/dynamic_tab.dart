// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Tabs Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const DynamicTabsScreen(),
    );
  }
}

class TabItem {
  final String name;
  final List<String> tabNames;
  final List<List<String>> tabContents;

  TabItem({
    required this.name,
    required this.tabNames,
    required this.tabContents,
  });
}

class DynamicTabsScreen extends StatefulWidget {
  const DynamicTabsScreen({super.key});

  @override
  _DynamicTabsScreenState createState() => _DynamicTabsScreenState();
}

class _DynamicTabsScreenState extends State<DynamicTabsScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int selectedItemIndex = 0;

  final List<TabItem> items = [
    TabItem(
      name: "Item 1 (2 tabs)",
      tabNames: ["System", "Device"],
      tabContents: [
        [
          "System Log Entry 1",
          "System Log Entry 2",
          "System Log Entry 3",
          "System Log Entry 4",
          "System Log Entry 5",
          "System Log Entry 6",
          "System Log Entry 7",
          "System Log Entry 8",
          "System Log Entry 9",
          "System Log Entry 10",
        ],
        [
          "Device Log Entry 1",
          "Device Log Entry 2",
          "Device Log Entry 3",
          "Device Log Entry 4",
          "Device Log Entry 5",
          "Device Log Entry 6",
          "Device Log Entry 7",
          "Device Log Entry 8",
        ],
      ],
    ),
    TabItem(
      name: "Item 2 (3 tabs)",
      tabNames: ["Network", "Storage", "Memory"],
      tabContents: [
        [
          "Network Connection 1",
          "Network Connection 2",
          "Network Connection 3",
          "Network Connection 4",
          "Network Connection 5",
        ],
        [
          "Storage Info 1",
          "Storage Info 2",
          "Storage Info 3",
          "Storage Info 4",
          "Storage Info 5",
          "Storage Info 6",
        ],
        [
          "Memory Usage 1",
          "Memory Usage 2",
          "Memory Usage 3",
          "Memory Usage 4",
        ],
      ],
    ),
    TabItem(
      name: "Item 3 (1 tab)",
      tabNames: ["Diagnostics"],
      tabContents: [
        [
          "Diagnostic Report 1",
          "Diagnostic Report 2",
          "Diagnostic Report 3",
          "Diagnostic Report 4",
          "Diagnostic Report 5",
          "Diagnostic Report 6",
          "Diagnostic Report 7",
        ],
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeTabController();
  }

  void _initializeTabController() {
    _tabController?.dispose();
    _tabController = TabController(
      length: items[selectedItemIndex].tabNames.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _selectItem(int index) {
    setState(() {
      selectedItemIndex = index;
      _initializeTabController();
    });
  }

  Widget _buildTabContent(List<String> content) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: content.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              title: Text(content[index]),
              subtitle: Text("Entry ${index + 1}"),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = items[selectedItemIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Tabs Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Item selector dropdown
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Item:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      initialValue: selectedItemIndex,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: items.asMap().entries.map((entry) {
                        return DropdownMenuItem<int>(
                          value: entry.key,
                          child: Text(entry.value.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _selectItem(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tab widget with fixed positioning (200px from top and bottom)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 100),
                child: Center(
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SizedBox(
                      width: 400,
                      height: 400,
                      child: DefaultTabController(
                        length: currentItem.tabNames.length,
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: TabBar(
                                controller: _tabController,
                                indicator: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                    // ignore: deprecated_member_use
                                  ).colorScheme.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                indicatorSize: TabBarIndicatorSize.tab,
                                labelColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                unselectedLabelColor: Theme.of(
                                  context,
                                ).colorScheme.onSurface,
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                unselectedLabelStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                                indicatorPadding: const EdgeInsets.all(4),
                                isScrollable: currentItem.tabNames.length > 4,
                                tabs: currentItem.tabNames
                                    .map(
                                      (name) => Tab(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          child: Text(name),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: TabBarView(
                                  controller: _tabController,
                                  children: currentItem.tabContents
                                      .map(
                                        (content) => _buildTabContent(content),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                            // Bottom action buttons
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                  // ignore: deprecated_member_use
                                ).colorScheme.surface.withOpacity(0.8),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Edit pressed'),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit, size: 16),
                                    label: const Text('Edit'),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Delete pressed'),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.delete, size: 16),
                                    label: const Text('Delete'),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Close pressed'),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.close, size: 16),
                                    label: const Text('Close'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
