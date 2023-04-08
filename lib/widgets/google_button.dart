import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grocery_shopping_with_admin_panel/provider/firebase_auth_provider.dart';
import 'package:grocery_shopping_with_admin_panel/screens/btm_bar.dart';
import 'package:provider/provider.dart';
import 'text_widget.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return authProvider.isLoading
        ? SpinKitThreeBounce()
        : Material(
            color: Colors.blue,
            child: InkWell(
              onTap: () {
                authProvider.signInWithGoogle(context);
                
              },
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  color: Colors.white,
                  child: Image.asset(
                    'images/google.png',
                    width: 40.0,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                TextWidget(
                    text: 'Sign in with google',
                    color: Colors.white,
                    textSize: 18)
              ]),
            ),
          );
  }
}
