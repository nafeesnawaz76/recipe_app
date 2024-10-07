import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class IsadminCheck extends GetxController {
  var isadmin = false.obs; // Observable boolean

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to toggle isAdmin state in Firebase
  void toggleAdmin() async {
    try {
      // Toggle the local state
      isadmin.toggle();

      // Get the current user
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Update the 'isAdmin' field in Firestore for the current user
        await _firestore.collection('users').doc(currentUser.uid).update({
          'isAdmin': isadmin.value,
        });
      }
    } catch (e) {
      print('Failed to update admin status: $e');
    }
  }

  // Function to fetch and set the initial value of isAdmin from Firestore
  void getAdminStatus() async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();

        if (userDoc.exists) {
          // Set the initial value of isAdmin from Firestore
          isadmin.value = userDoc['isAdmin'] ?? false;
        }
      }
    } catch (e) {
      print('Failed to get admin status: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    getAdminStatus(); // Fetch the admin status when the controller is initialized
  }
}
