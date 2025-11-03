import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Markdown Plus Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const MarkdownDemoPage(),
    );
  }
}

class MarkdownDemoPage extends StatelessWidget {
  const MarkdownDemoPage({super.key});

  static const String markdownData = '''
# Markdown syntax guide

## Headers

# This is a Heading h1
## This is a Heading h2
###### This is a Heading h6

## Emphasis

*This text will be italic*  
_This will also be italic_

**This text will be bold**  
__This will also be bold__

_You **can** combine them_

## Lists

### Unordered

* Item 1
* Item 2
* Item 2a
* Item 2b
    * Item 3a
    * Item 3b

### Ordered

1. Item 1
2. Item 2
3. Item 3
    1. Item 3a
    2. Item 3b

## Images

![This is an alt text.](https://picsum.photos/500/300 "This is a sample image.")

![This is an alt text.](https://picsum.photos/400/300 "This is a image.")

## Links

You may be using [Markdown Live Preview](https://markdownlivepreview.com/).

## Blockquotes

> Markdown is a lightweight markup language with plain-text-formatting syntax, created in 2004 by John Gruber with Aaron Swartz.
>
>> Markdown is often used to format readme files, for writing messages in online discussion forums, and to create rich text using a plain text editor.

## Tables

| Left columns  | Right columns |
| ------------- |:-------------:|
| left foo      | right foo     |
| left bar      | right bar     |
| left baz      | right baz     |

## Blocks of code

```
let message = 'Hello world';
alert(message);
```

## Inline code

This web site is using `markedjs/marked`.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Markdown Plus Demo'),
        elevation: 2,
      ),
      body: Markdown(
        data: markdownData,
        selectable: true,
        imageBuilder: (Uri uri, String? title, String? alt) {
          // Default values
          double width = 300;
          double height = 200;
          BoxFit fit = BoxFit.cover;
          bool centerImage = true;

          // Customize based on alt text
          if (alt != null) {
            if (alt.contains('sample')) {
              // Specific styling for images with "sample" in alt text
              width = 400;
              height = 250;
              fit = BoxFit.contain;
            }
          }

          // Or customize based on URL/URI
          String imageUrl = uri.toString();
          if (imageUrl.contains('500/300')) {
            width = 500;
            height = 300;
            centerImage = true;
          }

          // Or customize based on title
          if (title != null && title.contains('small')) {
            width = 150;
            height = 100;
          }

          Widget imageWidget = Image.network(
            imageUrl,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: width,
                height: height,
                color: Colors.grey.shade300,
                child: const Icon(Icons.broken_image, size: 50),
              );
            },
          );

          // Return centered or not based on your condition
          return centerImage ? Center(child: imageWidget) : imageWidget;
        },
        styleSheet: MarkdownStyleSheet(
          h1: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          h2: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          h6: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          blockquote: const TextStyle(color: Colors.grey),
          blockquoteDecoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          code: TextStyle(
            backgroundColor: Colors.grey.shade200,
            fontFamily: 'monospace',
          ),
          codeblockDecoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
