import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:netlab/core/components/animations.dart';
import 'package:netlab/core/constants/app_text.dart';
import 'package:netlab/tutorial/models/tutorial_content.dart';
import 'package:netlab/tutorial/widgets/content/content_blocks/content_blocks.dart';

class TutorialContentViewer extends StatefulWidget {
  final TutorialSection section;
  final int itemIndex;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const TutorialContentViewer({
    super.key,
    required this.section,
    required this.itemIndex,
    this.onPrevious,
    this.onNext,
  });

  @override
  State<TutorialContentViewer> createState() => _TutorialContentViewerState();
}

class _TutorialContentViewerState extends State<TutorialContentViewer> {
  late PageController _pageController;
  late int _currentImageIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentImageIndex = 0;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TutorialContentViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemIndex != widget.itemIndex) {
      _pageController.jumpToPage(0);
      setState(() {
        _currentImageIndex = 0;
      });
    }
  }

  // No unused methods

  @override
  Widget build(BuildContext context) {
    final item = widget.section.items[widget.itemIndex];
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBreadcrumb(context),
          const SizedBox(height: 32),

          // Fixed Content: Title & Description
          KeyedSubtree(
            key: ValueKey('title-${widget.itemIndex}'),
            child: AnimationPresets.titleFadeIn(
              child: Text(
                item.title,
                style: AppTextStyles.headerLarge.copyWith(
                  color: cs.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          KeyedSubtree(
            key: ValueKey('description-${widget.itemIndex}'),
            child: AnimationPresets.textFadeIn(
              delay: 200,
              child: Text(
                item.description,
                style: AppTextStyles.bodyLarge.copyWith(
                  height: 1.6,
                  color: cs.onSurface.withAlpha(200),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Content Container with Image and Text
          Container(
            constraints: const BoxConstraints(maxHeight: 350),
            child: KeyedSubtree(
              key: ValueKey('content-${widget.itemIndex}'),
              child: AnimationPresets.cardEntrance(
                delay: 400,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                  itemCount: item.content.length,
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildContentBlock(item.content[index]),
                          if (item.images != null &&
                              index < item.images!.length)
                            ImageBlock(
                              imagePath: item.images![index].path,
                              imagePathDark: item.images![index].pathDark,
                              imagePathLight: item.images![index].pathLight,
                            ),
                          if (item.imagePath != null && item.images == null)
                            ImageBlock(imagePath: item.imagePath!),
                          const SizedBox(height: 24),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Slide Indicators
          KeyedSubtree(
            key: ValueKey('indicators-${widget.itemIndex}'),
            child: AnimationPresets.pageIndicator(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  item.content.length + (item.imagePath != null ? 1 : 0),
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == index
                          ? cs.primary
                          : cs.onSurface.withAlpha(20),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Navigation
          _buildNavigation(context),
        ],
      ),
    );
  }

  Widget _buildBreadcrumb(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AnimationPresets.textFadeIn(
      delay: 0,
      child: Row(
        children: [
          widget.section.isHugeIcon
              ? HugeIcon(icon: widget.section.icon, size: 16, color: cs.primary)
              : Icon(widget.section.icon, size: 16, color: cs.primary),
          const SizedBox(width: 8),
          Text(
            widget.section.title,
            style: AppTextStyles.subtitleLarge.copyWith(
              color: cs.primary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, size: 16),
          const SizedBox(width: 8),
          Text(
            'Tutorial ${widget.itemIndex + 1} of ${widget.section.items.length}',
            style: AppTextStyles.subtitleLarge.copyWith(
              // color: cs.onSurface.withAlpha(160),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentBlock(ContentBlock block) {
    switch (block.type) {
      case ContentBlockType.text:
        return TextBlock(content: block.content as String);

      case ContentBlockType.image:
        return ImageBlock(
          imagePath: block.content as String,
          title: block.title,
        );

      case ContentBlockType.numberedList:
        return NumberedListBlock(
          items: List<String>.from(block.content as List),
          title: block.title,
        );

      case ContentBlockType.bulletList:
        return BulletListBlock(
          items: List<String>.from(block.content as List),
          title: block.title,
        );

      case ContentBlockType.note:
        return NoteBlock(content: block.content as String, type: NoteType.note);

      case ContentBlockType.tip:
        return NoteBlock(content: block.content as String, type: NoteType.tip);

      case ContentBlockType.warning:
        return NoteBlock(
          content: block.content as String,
          type: NoteType.warning,
        );

      case ContentBlockType.definition:
        final definitions = (block.content as List)
            .map((d) => DefinitionItem.fromJson(d))
            .toList();
        return DefinitionBlock(definitions: definitions);

      case ContentBlockType.table:
        return TableBlock(
          rows: (block.content as List)
              .map((row) => List<String>.from(row))
              .toList(),
          title: block.title,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNavigation(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final item = widget.section.items[widget.itemIndex];
    final totalSlides = item.content.length + (item.imagePath != null ? 1 : 0);

    return Column(
      children: [
        // Slide Navigation
        if (totalSlides > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _currentImageIndex > 0
                    ? () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      )
                    : null,
                icon: const Icon(Icons.arrow_back_ios),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: _currentImageIndex < totalSlides - 1
                    ? () => _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      )
                    : null,
                icon: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        const SizedBox(height: 16),
        // Tutorial Navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.onPrevious != null)
              AnimationPresets.buttonBounce(
                delay: 600,
                child: OutlinedButton.icon(
                  onPressed: widget.onPrevious,
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: Text(
                    'Previous Tutorial',
                    style: AppTextStyles.buttonMedium,
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              )
            else
              const SizedBox(),

            if (widget.onNext != null)
              AnimationPresets.buttonBounce(
                delay: 600,
                child: FilledButton.icon(
                  onPressed: widget.onNext,
                  label: Text(
                    'Next Tutorial',
                    style: AppTextStyles.buttonMedium,
                  ),
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  style: FilledButton.styleFrom(
                    backgroundColor: cs.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              )
            else
              const SizedBox(),
          ],
        ),
      ],
    );
  }
}
