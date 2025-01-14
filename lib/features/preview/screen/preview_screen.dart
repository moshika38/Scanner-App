import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:scanner/core/utils/colors.dart';

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
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              child: pdfPath != ""
                  ? PDFView(
                      filePath: pdfPath,
                    )
                  : const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 6,
                          color: AppColors.brown,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
