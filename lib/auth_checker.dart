import 'package:flutter/material.dart';
import 'package:grocery_shopping_with_admin_panel/screens/btm_bar.dart';
import 'package:provider/provider.dart';
import 'provider/firebase_auth_provider.dart';
import 'screens/auth/login.dart';

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isAuthenticate) {
      return const BottomBarScreen();
    } else {
      return const LoginScreen();
    }
  }
}
