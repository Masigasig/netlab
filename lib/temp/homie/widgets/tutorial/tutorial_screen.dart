import 'package:flutter/material.dart';
import 'models/tutorial_content.dart';
import 'services/tutorial_json_service.dart';
import 'widgets/sidebar/tutorial_sidebar.dart';
import 'widgets/content/tutorial_content_viewer.dart';
import 'widgets/welcome_screen.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  List<TutorialSection>? _sections;
  bool _isLoading = true;
  String? _error;

  final Set<String> _expandedSections = {};
  String? _selectedSectionId;
  int? _selectedItemIndex;

  @override
  void initState() {
    super.initState();
    _loadTutorials();
  }

  Future<void> _loadTutorials() async {
    try {
      final sections = await TutorialJsonService.loadTutorials();
      setState(() {
        _sections = sections;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _toggleSection(String sectionId) {
    setState(() {
      if (_expandedSections.contains(sectionId)) {
        _expandedSections.remove(sectionId);
        if (_selectedSectionId == sectionId) {
          _selectedSectionId = null;
          _selectedItemIndex = null;
        }
      } else {
        _expandedSections.add(sectionId);
      }
    });
  }

  void _selectItem(String sectionId, int index) {
    setState(() {
      _selectedSectionId = sectionId;
      _selectedItemIndex = index;
      _expandedSections.add(sectionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Failed to load tutorials',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _loadTutorials();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_sections == null || _sections!.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No tutorials available')),
      );
    }

    final selectedSection = _selectedSectionId != null
        ? _sections!.firstWhere((s) => s.id == _selectedSectionId)
        : null;

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          TutorialSidebar(
            sections: _sections!,
            expandedSections: _expandedSections,
            selectedSectionId: _selectedSectionId,
            selectedItemIndex: _selectedItemIndex,
            onToggleSection: _toggleSection,
            onSelectItem: _selectItem,
          ),

          // Content Area
          Expanded(
            child: selectedSection == null || _selectedItemIndex == null
                ? const WelcomeScreen()
                : TutorialContentViewer(
                    section: selectedSection,
                    itemIndex: _selectedItemIndex!,
                    onPrevious: _selectedItemIndex! > 0
                        ? () => _selectItem(
                            _selectedSectionId!,
                            _selectedItemIndex! - 1,
                          )
                        : null,
                    onNext:
                        _selectedItemIndex! < selectedSection.items.length - 1
                        ? () => _selectItem(
                            _selectedSectionId!,
                            _selectedItemIndex! + 1,
                          )
                        : null,
                  ),
          ),
        ],
      ),
    );
  }
}
