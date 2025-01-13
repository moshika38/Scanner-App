import 'package:flutter/material.dart';
import 'package:scanner/core/utils/colors.dart';
import 'package:scanner/features/auth/widget/login_btn.dart';
import 'package:scanner/features/home/screen/home_screen.dart';
import 'package:scanner/features/widgets/page_route.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo or App Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.brown,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.document_scanner,
                  size: 80,
                  color: AppColors.lightGrey,
                ),
              ),

              const SizedBox(height: 40),

              // App Name
              Text(
                'Document Scanner',
                style: Theme.of(context).textTheme.displayLarge,
              ),

              const SizedBox(height: 10),

              // Tagline
              Text(
                'Secure • Quick • Efficient',
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const SizedBox(height: 50),

              // Google Sign In Button
              LoginBtn(
                signInWithGoogle: () {
                  AppPageRouteing.pushReplacement(context, HomeScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
