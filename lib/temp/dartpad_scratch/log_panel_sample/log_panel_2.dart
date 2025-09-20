import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern Card UI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 239, 239, 239),
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(title: const Text('Modern Card UI')),
        body: const Center(
          child: Padding(padding: EdgeInsets.all(16.0), child: CardWithTabs()),
        ),
      ),
    );
  }
}

class CardWithTabs extends StatelessWidget {
  const CardWithTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Modern segmented Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: SizedBox(
                height: 40,
                child: TabBar(
                  indicator: BoxDecoration(
                    color: Theme.of(
                      context,
                      // ignore: deprecated_member_use
                    ).colorScheme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor: Colors.grey[700],
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  splashFactory: NoSplash.splashFactory, // no ripple clutter
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  tabs: const [
                    Tab(child: SizedBox(height: 20, child: Text('Overview'))),
                    Tab(child: SizedBox(height: 20, child: Text('Details'))),
                  ],
                ),
              ),
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            // Content area
            Container(
              height: 180,
              padding: const EdgeInsets.all(20),
              child: const TabBarView(
                children: [_OverviewTab(), _DetailsTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Overview",
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "Quick summary of the data or status. You can put charts or stats here.",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
        ),
      ],
    );
  }
}

class _DetailsTab extends StatelessWidget {
  const _DetailsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(
          leading: Icon(Icons.info_outline),
          title: Text("Detail Item 1"),
          subtitle: Text("More explanation about this item."),
        ),
        ListTile(
          leading: Icon(Icons.settings_outlined),
          title: Text("Detail Item 2"),
          subtitle: Text("Configuration details or settings."),
        ),
      ],
    );
  }
}
