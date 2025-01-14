import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:scanner/core/utils/theme.dart';
import 'package:scanner/features/home/providers/document_provider.dart';
import 'package:scanner/features/home/screen/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scanner/features/onBoarding/screen/on_boarding_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  Stripe.publishableKey = dotenv.env["STRIPE_PUBLISHABLE_KEY"] ?? "";
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DocumentProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doc scanner',
      theme: AppTheme.lightTheme,
      home: FirebaseAuth.instance.currentUser != null
          ? const HomeScreen()
          : const OnBoardingScreen(),
    );
  }
}
