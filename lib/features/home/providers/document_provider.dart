import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scanner/features/home/services/path_services.dart';
import 'package:scanner/features/widgets/snack_bar.dart';
import 'package:scanner/models/doc_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';

class DocumentProvider extends ChangeNotifier {
  final DocumentScanner _documentScanner =
      DocumentScanner(options: DocumentScannerOptions());

// scan new document
  Future<void> scanDocument(BuildContext context) async {
    try {
      final result = await _documentScanner.scanDocument();
      if (result.images.isNotEmpty) {
        // Use the first image path from the result
        final firstImagePath = result.images.first;

        // Save the image as a PDF
        await _saveAsPdf(firstImagePath);
        await deleteImage(firstImagePath);

        // Navigate to the preview page with the PDF path
        if (context.mounted) {
          CustomSnackBar.showSuccess(context, "Document scanned successfully");
        }
      }
      notifyListeners();
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.showError(context, "Error: $e");
      }
      notifyListeners();
    }
  }

  // save as pdf
  Future<String> _saveAsPdf(String imagePath) async {
    try {
      final pdf = pw.Document();

      final image = pw.MemoryImage(File(imagePath).readAsBytesSync());
      pdf.addPage(pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Image(image),
        ),
      ));

      final downloadsDir = await PathServices.getLocation();
      if (downloadsDir.isNotEmpty) {
        final pdfPath = '$downloadsDir/${_documentScanner.id}.pdf';
        final file = File(pdfPath);

        await file.writeAsBytes(await pdf.save());
        notifyListeners();
        return pdfPath;
      } else {
        throw Exception('Downloads directory not found');
      }
    } catch (e) {
      throw Exception('Failed to save PDF: $e');
    }
  }

  // delete image
  Future<void> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print("Error deleting image: $e");
    }
  }

  // rename doc name
  Future<void> renameFile(
      BuildContext context, String filePath, String newName) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final directory = file.parent.path;
        final newFilePath = '$directory/$newName';
        await file.rename(newFilePath);
        if (context.mounted) {
          CustomSnackBar.showSuccess(context, "Document renamed successfully");
        }
      } else {
        if (context.mounted) {
          CustomSnackBar.showError(context, "Document not found");
        }
      }
      notifyListeners();
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.showError(context, "Error renaming Document: $e");
      }
      notifyListeners();
    }
  }

  Future<List<DocModel>> getPdfFiles() async {
    final directoryPath = await PathServices.getLocation();
    final directory = Directory(directoryPath);
    final List<DocModel> docList = [];

    if (await directory.exists()) {
      final files = directory.listSync(recursive: true);

      for (var file in files) {
        if (file is File && file.path.endsWith('.pdf')) {
          final fileName = file.uri.pathSegments.last;
          final fileSize = await file.length();
          final fileTime = await file.lastModified();

          docList.add(DocModel(
            name: fileName,
            time: fileTime.toString(),
            size: '${(fileSize / 1024).toStringAsFixed(2)} KB',
            path: file.path,
          ));
        }
      }
    }
    return docList.reversed.toList();
  }

  Future<void> deletePdf(BuildContext context, String pdfPath) async {
    try {
      final file = File(pdfPath);
      if (await file.exists()) {
        await file.delete();

        if (context.mounted) {
          CustomSnackBar.showSuccess(context, "Document deleted successfully");
        }
      } else {
        if (context.mounted) {
          CustomSnackBar.showError(context, "Document not found");
        }
      }
      notifyListeners();
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.showError(context, "Error deleting Document: $e");
      }
      notifyListeners();
    }
  }

  void notify() {
    notifyListeners();
  }
}
