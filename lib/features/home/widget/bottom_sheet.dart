import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/core/utils/colors.dart';
import 'package:scanner/features/home/providers/document_provider.dart';

class AppBottomSheet {
  static Future<bool?> delete(BuildContext context, String imagePath) {
    return showModalBottomSheet<bool>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Delete Document',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 15),
            Text(
              'Are you sure you want to delete this document?',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                Consumer<DocumentProvider>(
                  builder: (context, docServices, child) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                    ),
                    onPressed: () {
                      docServices.deletePdf(context, imagePath);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // rename document
  static Future<String?> showRename(
      BuildContext context, String imagePath, String currentName) {
    final TextEditingController nameController =
        TextEditingController(text: currentName);

    return showModalBottomSheet<String>(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Rename Document',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.lightGrey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Enter new name',
                ),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  Consumer<DocumentProvider>(
                    builder: (context, docServices, child) => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brown,
                      ),
                      onPressed: () {
                        if (nameController.text.isEmpty) {
                          nameController.text = currentName;
                        }
                        if (!nameController.text.endsWith('.pdf')) {
                          nameController.text += '.pdf';
                        }
                        docServices.renameFile(
                            context, imagePath, nameController.text);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Rename',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
