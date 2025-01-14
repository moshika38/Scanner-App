import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scanner/core/utils/colors.dart';
import 'package:scanner/features/home/stripe/stripe.dart';
import 'package:scanner/features/widgets/snack_bar.dart';

class UpgradeReminder {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => AnimatedPadding(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.darkGrey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              Icon(
                Icons.workspace_premium,
                size: 64,
                color: AppColors.brown,
              ),
              const SizedBox(height: 16),
              Text(
                'Upgrade to Premium',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'You have reached your free scan limit (10 scans). Upgrade to premium for unlimited scanning!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey,
                      height: 1.5,
                    ),
              ),
              Text(
                'OR',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey,
                      height: 1.5,
                    ),
              ),
              Text(
                'Try again next day !',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.brown,
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Add premium upgrade logic here
                    init(
                      email:
                          FirebaseAuth.instance.currentUser!.email.toString(),
                      name: FirebaseAuth.instance.currentUser!.displayName ??
                          "Guest",
                      context: context,
                    );
                    Navigator.of(context).pop();
                    CustomSnackBar.showSuccess(context,
                        "Waiting for approval, Payment window will open in a few seconds");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Upgrade Now',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'Maybe Later',
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
