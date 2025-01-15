import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:scanner/models/user_model.dart';

class ScanningUserProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get current user details
  Future<UserModel?> getUserDetails() async {
    final id = FirebaseAuth.instance.currentUser?.uid;
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(id).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // update scanned count
  Future<void> updateCount() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await firestore.collection('users').doc(uid).get();
    if (snapshot.exists) {
      final user = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      int currentScanned = user.currentScanned;
      if (currentScanned != 10) {
        // update scanned count
        await firestore.collection('users').doc(uid).update({
          'current_scanned': currentScanned + 1,
        });
        notifyListeners();
      }
    }
  }

  // check validity
  Future<bool> checkAndUpdateUserValidity() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await firestore.collection('users').doc(uid).get();
    if (snapshot.exists) {
      final user = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      String date = user.currentDate.split(' ')[0];
      if (date != DateTime.now().toString().split(' ')[0]) {
        await firestore.collection('users').doc(uid).update({
          'current_scanned': 1,
          'current_date': DateTime.now().toString(),
        });
        notifyListeners();
        return true;
      } else {
        notifyListeners();
        return false;
      }
    } else {
      notifyListeners();
      return false;
    }
  }

  // update user plan
  Future<void> updateUserPlan(String plan) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await firestore.collection('users').doc(uid).get();
    if (snapshot.exists) {
      final user = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      if (user.currentPlan != plan) {
        await firestore.collection('users').doc(uid).update({
          'current_plan': plan,
        });
        notifyListeners();
      }
    }
    notifyListeners();
  }
}
