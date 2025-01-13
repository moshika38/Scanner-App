import 'package:flutter/material.dart';

class PreviewScreen extends StatelessWidget {
  final String pdfPath;

  const PreviewScreen({
    super.key,
    required this.pdfPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PDF Preview',
          style:
              Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
            },
          ),
        ],
      ),
      body: Text("data"),
    );
  }
}
