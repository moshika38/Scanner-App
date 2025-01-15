import 'package:flutter/material.dart';
import 'package:scanner/core/utils/colors.dart';
import 'package:scanner/features/auth/services/user_auth_services.dart';
import 'package:scanner/features/auth/widget/login_btn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

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
                signInWithGoogle: () async {
                  isLoading = true;
                  setState(() {});
                  if (isLoading == false) {
                    await UserAuthServices().signInWithGoogle();
                    context.mounted
                        ? await UserAuthServices().createUser(context)
                        : null;
                  }
                  isLoading = false;
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              isLoading
                  ? Text(
                      'Loading...',
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
