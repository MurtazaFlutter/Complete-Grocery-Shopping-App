import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_shopping_with_admin_panel/consts/auth_constans.dart';
import 'package:grocery_shopping_with_admin_panel/widgets/alert_message.dart';
import '../services/global_methods.dart';

class UserDataProvider extends ChangeNotifier {
  String? _email;
  String? _name;
  String? _address;
  bool _isLoading = false;

  String? get email => _email;
  String? get name => _name;
  String? get address => _address;
  bool get isLoading => _isLoading;

  Future<void> getUserData(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final User? user = auth.currentUser;
    if (user == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final String uid = user.uid;
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      // ignore: unnecessary_null_comparison
      if (userDoc == null) {
        return;
      } else {
        _email = userDoc.get('email');
        _name = userDoc.get('name');
        _address = userDoc.get('shipping-address');
      }
    } catch (error) {
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAddress(
      TextEditingController controller, BuildContext context) async {
    String uid = user!.uid;
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'shipping address': controller.text,
      });
    } catch (error) {
      alertMessage(
        error.toString(),
      );
    }
    _address = controller.text;
    notifyListeners();
    Navigator.pop(context);
  }
}
