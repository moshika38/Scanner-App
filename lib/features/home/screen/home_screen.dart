
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/core/utils/colors.dart';
import 'package:scanner/features/home/providers/document_provider.dart';
import 'package:scanner/features/home/providers/scanning_user_provider.dart';
import 'package:scanner/features/home/widget/action_btn.dart';
import 'package:scanner/features/home/widget/document_card.dart';
import 'package:scanner/features/home/widget/end_drawer.dart';
import 'package:scanner/features/home/widget/upgrade_reminder.dart';
import 'package:scanner/models/doc_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool? isPro;
  int? scanCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      endDrawer: EndDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Document\nScanner',
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: 25,
                                  height: 1.2,
                                ),
                      ),
                      Builder(
                        builder: (BuildContext context) => GestureDetector(
                          onTap: () => Scaffold.of(context).openEndDrawer(),
                          child: CircleAvatar(
                            backgroundColor: AppColors.brown,
                            radius: 22,
                            child: const Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Consumer<ScanningUserProvider>(
                    builder: (context, scanningUserProvider, child) =>
                        FutureBuilder(
                      future: scanningUserProvider.getUserDetails(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final user = snapshot.data!;
                          isPro = user.currentPlan == 'pro';
                          scanCount = user.currentScanned;
                          return Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.brown,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ActionBtn(
                                  context: context,
                                  icon: Icons.camera_alt,
                                  label: 'Scan Now',
                                  onTap: () async {
                                    // scanning new document
                                    if (isPro == false) {
                                      bool isAvailable = await context
                                          .read<ScanningUserProvider>()
                                          .checkAndUpdateUserValidity();
                                      if (!isAvailable) {
                                        if (scanCount! >= 5) {
                                          if (context.mounted) {
                                            UpgradeReminder.show(context);
                                          }
                                        } else {
                                          if (context.mounted) {
                                            await context
                                                .read<DocumentProvider>()
                                                .scanDocument(context);
                                            await context
                                                .read<ScanningUserProvider>()
                                                .updateCount();
                                          }
                                        }
                                      } else {
                                        if (context.mounted) {
                                          await context
                                              .read<DocumentProvider>()
                                              .scanDocument(context);
                                        }
                                      }
                                    } else {
                                      if (context.mounted) {
                                        await context
                                            .read<DocumentProvider>()
                                            .scanDocument(context);
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container(
                            height: 100,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.brown,
                              borderRadius: BorderRadius.circular(24),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Scans',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(fontSize: 20),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.sort, color: AppColors.brown),
                        label: const Text(
                          'Sort by',
                          style: TextStyle(color: AppColors.brown),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Consumer<DocumentProvider>(
              builder: (context, documentProvider, child) => FutureBuilder(
                future: documentProvider.getPdfFiles(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final docList = snapshot.data as List<DocModel>;
                    if (docList.isEmpty) {
                      return Center(
                        child: Text(
                          'No documents found',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.grey),
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: docList.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: DocumentCard(
                            context: context,
                            name: docList[index].name,
                            size: docList[index].size,
                            path: docList[index].path,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
