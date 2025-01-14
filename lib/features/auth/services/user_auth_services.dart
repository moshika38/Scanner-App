import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scanner/features/auth/screen/login_screen.dart';
import 'package:scanner/features/home/screen/home_screen.dart';
import 'package:scanner/features/widgets/page_route.dart';
import 'package:scanner/models/user_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserAuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // google login
  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    if (FirebaseAuth.instance.currentUser != null) {
      await createUser();
      if (context.mounted) {
        AppPageRouteing.pushReplacement(context, HomeScreen());
      }
    }
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // create collection
  Future<void> createUser() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Check if user exists
    final userDoc = await _firestore.collection('users').doc(userId).get();

    if (!userDoc.exists) {
      final user = UserModel(
        id: userId,
        email: FirebaseAuth.instance.currentUser!.email!,
        currentPlan: "free",
        currentDate: DateTime.now().toIso8601String(),
        currentScanned: 0,
      );
      await _firestore.collection('users').doc(user.id).set(user.toJson());
    }
  }

  // logout
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      AppPageRouteing.pushReplacement(context, LoginScreen());
    }
  }
}
