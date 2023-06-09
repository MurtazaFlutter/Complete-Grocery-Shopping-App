import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_shopping_with_admin_panel/provider/firebase_auth_provider.dart';
import 'package:grocery_shopping_with_admin_panel/provider/user_info_provider.dart';
import 'package:grocery_shopping_with_admin_panel/screens/auth/forget_pass.dart';
import 'package:grocery_shopping_with_admin_panel/screens/auth/login.dart';
import 'package:provider/provider.dart';
import '../consts/auth_constans.dart';
import '../provider/dark_theme_provider.dart';
import '../services/global_methods.dart';
import '../widgets/text_widget.dart';
import 'orders/orders_screen.dart';
import 'viewed_recently/viewed_recently.dart';
import 'wishlist/wishlist_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextController =
      TextEditingController(text: "");
  @override
  void dispose() {
    _addressTextController.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   Provider.of<UserDataProvider>(context, listen: false).getUserData(context);
  //   super.initState();
  // }

  final User? user = auth.currentUser;
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              RichText(
                text: TextSpan(
                  text: 'Hi,  ',
                  style: const TextStyle(
                    color: Colors.cyan,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: userDataProvider.name ?? '',
                        style: TextStyle(
                          color: color,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print('My name is pressed');
                          }),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextWidget(
                text: userDataProvider.email ?? '',
                color: color,
                textSize: 18,
                // isTitle: true,
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 20,
              ),
              _listTiles(
                title: 'Address 2',
                subtitle: 'My subtitle',
                icon: IconlyLight.profile,
                onPressed: () async {
                  await _showAddressDialog();
                },
                color: color,
              ),
              _listTiles(
                title: 'Orders',
                icon: IconlyLight.bag,
                onPressed: () {
                  GlobalMethods.navigateTo(
                      ctx: context, routeName: OrdersScreen.routeName);
                },
                color: color,
              ),
              _listTiles(
                title: 'Wishlist',
                icon: IconlyLight.heart,
                onPressed: () {
                  GlobalMethods.navigateTo(
                      ctx: context, routeName: WishlistScreen.routeName);
                },
                color: color,
              ),
              _listTiles(
                title: 'Viewed',
                icon: IconlyLight.show,
                onPressed: () {
                  GlobalMethods.navigateTo(
                      ctx: context, routeName: ViewedRecentlyScreen.routeName);
                },
                color: color,
              ),
              _listTiles(
                title: 'Forget password',
                icon: IconlyLight.unlock,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const ForgetPasswordScreen()),
                    ),
                  );
                },
                color: color,
              ),
              SwitchListTile(
                title: TextWidget(
                  text: themeState.getDarkTheme ? 'Dark mode' : 'Light mode',
                  color: color,
                  textSize: 18,
                  isTitle: true,
                ),
                secondary: Icon(themeState.getDarkTheme
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined),
                onChanged: (bool value) {
                  setState(() {
                    themeState.setDarkTheme = value;
                  });
                },
                value: themeState.getDarkTheme,
              ),
              _listTiles(
                title: user == null ? 'Login' : 'Logout',
                icon: user == null ? IconlyLight.login : IconlyLight.logout,
                onPressed: () {
                  if (user == null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: ((context) => const LoginScreen()),
                      ),
                    );
                    return;
                  }
                  GlobalMethods.warningDialog(
                      title: 'Sign out',
                      subtitle: 'Do you want to sign out?',
                      fct: () async {
                        await authProvider.signOut();
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => const LoginScreen()),
                        ));
                      },
                      context: context);
                },
                color: color,
              ),

              // listTileAsRow(),
            ],
          ),
        ),
      ),
    ));
  }

  Future<void> _showAddressDialog() async {
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update'),
            content: TextField(
              controller: _addressTextController,
              maxLines: 5,
              decoration: const InputDecoration(hintText: "Your address"),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await userDataProvider.updateAddress(
                    _addressTextController,
                    context,
                  );
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
  }

  Widget _listTiles({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    return ListTile(
      title: TextWidget(
        text: title,
        color: color,
        textSize: 22,
        // isTitle: true,
      ),
      subtitle: TextWidget(
        text: subtitle ?? "",
        color: color,
        textSize: 18,
      ),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: () {
        onPressed();
      },
    );
  }

// // Alternative code for the listTile.
//   Widget listTileAsRow() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: <Widget>[
//           const Icon(Icons.settings),
//           const SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: const [
//               Text('Title'),
//               Text('Subtitle'),
//             ],
//           ),
//           const Spacer(),
//           const Icon(Icons.chevron_right)
//         ],
//       ),
//     );
//   }
}
