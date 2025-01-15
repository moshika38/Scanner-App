import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/core/utils/colors.dart';
import 'package:scanner/features/auth/services/user_auth_services.dart';
import 'package:scanner/features/home/providers/document_provider.dart';
import 'package:scanner/features/home/providers/scanning_user_provider.dart';
import 'package:scanner/features/home/services/path_services.dart';
import 'package:scanner/features/home/widget/upgrade_reminder.dart';
import 'package:scanner/models/user_model.dart';

class EndDrawer extends StatefulWidget {
  const EndDrawer({super.key});

  @override
  State<EndDrawer> createState() => _EndDrawerState();
}

class _EndDrawerState extends State<EndDrawer> {
  String selectedFolderPath = "";
  Future<void> selectFolder() async {
    String? result = await FilePicker.platform.getDirectoryPath();
    PathServices.saveLocation(result.toString());
    setState(() {
      selectedFolderPath = result ?? "Failed to select folder";
    });
    if (mounted) {
      context.read<DocumentProvider>().notify();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ScanningUserProvider>(
        builder: (context, scanningUserProvider, child) => FutureBuilder(
          future: scanningUserProvider.getUserDetails(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final user = snapshot.data as UserModel;
              return Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 32, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.brown,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Scanner Menu',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 24),
                          user.currentPlan == "free"
                              ? _freeUserCard(context, user.currentScanned)
                              : _premiumUserCard(context),
                        ],
                      ),
                    ),
                    user.currentPlan == "free"
                        ? ListTile(
                            leading: const Icon(Icons.upgrade),
                            title: const Text('Upgrade to Premium'),
                            subtitle: const Text('Unlimited scans & features'),
                            onTap: () {
                              Navigator.pop(context);
                              UpgradeReminder.show(context);
                            },
                          )
                        : SizedBox.shrink(),
                    ListTile(
                      leading: const Icon(Icons.folder),
                      title: const Text('Scanned Documents'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    FutureBuilder(
                      future: PathServices.getLocation(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          selectedFolderPath = snapshot.data as String;
                          return ListTile(
                            leading: const Icon(Icons.save),
                            title: const Text('Storage Location'),
                            subtitle: Text(
                              selectedFolderPath,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            onTap: () {
                              selectFolder();
                            },
                          );
                        } else {
                          return ListTile(
                            leading: const Icon(Icons.save),
                            title: const Text('Storage Location'),
                            subtitle: const Text('Loading ...'),
                            onTap: () {
                              selectFolder();
                            },
                          );
                        }
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.help),
                      title: const Text('Help & Support'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      title: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () {
                        // Add logout logic here
                        Navigator.pop(context);
                        UserAuthServices().logout(context);
                      },
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 6,
                    color: AppColors.brown,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _freeUserCard(BuildContext context, int value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.star_outline,
                color: Colors.amber,
              ),
              const SizedBox(width: 8),
              Text(
                'Free Plan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value / 5,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            '$value/5 scans remaining',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
          ),
        ],
      ),
    );
  }

  Widget _premiumUserCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.withOpacity(0.3),
            Colors.amber.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.star, // Filled star for premium
                color: Colors.amber,
              ),
              const SizedBox(width: 8),
              Text(
                'Premium Plan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Unlimited scans available',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'All premium features unlocked',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.amber[100],
                ),
          ),
        ],
      ),
    );
  }
}
