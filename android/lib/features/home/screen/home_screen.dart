import 'package:flutter/material.dart';
import 'package:scanner/core/utils/colors.dart';
import 'package:scanner/features/home/widget/action_btn.dart';
import 'package:scanner/features/home/widget/document_card.dart';
import 'package:scanner/features/home/widget/end_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                  Container(
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
                          onTap: () {},
                        ),
                      ],
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
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: 10,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DocumentCard(
                    context: context,
                    index: index,
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
