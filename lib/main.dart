import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'consts/theme_data.dart';
import 'inner_screens/category_products.dart';
import 'inner_screens/feeds_screen.dart';
import 'inner_screens/on_sale_screen.dart';
import 'inner_screens/product_details.dart';
import 'provider/dark_theme_provider.dart';
import 'provider/products_provider.dart';
import 'screens/auth/forget_pass.dart';
import 'screens/auth/login.dart';
import 'screens/auth/register.dart';
import 'screens/btm_bar.dart';
import 'screens/orders/orders_screen.dart';
import 'screens/viewed_recently/viewed_recently.dart';
import 'screens/wishlist/wishlist_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return themeChangeProvider;
        }),
        ChangeNotifierProvider(create: (_) {
          return ProductsProvider();
        })
      ],
      child:
          Consumer<DarkThemeProvider>(builder: (context, themeProvider, child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: Styles.themeData(themeProvider.getDarkTheme, context),
            home: const BottomBarScreen(),
            routes: {
              OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
              FeedsScreen.routeName: (ctx) => const FeedsScreen(),
              ProductDetails.routeName: (ctx) => const ProductDetails(),
              WishlistScreen.routeName: (ctx) => const WishlistScreen(),
              OrdersScreen.routeName: (ctx) => const OrdersScreen(),
              ViewedRecentlyScreen.routeName: (ctx) =>
                  const ViewedRecentlyScreen(),
              RegisterScreen.routeName: (ctx) => const RegisterScreen(),
              LoginScreen.routeName: (ctx) => const LoginScreen(),
              ForgetPasswordScreen.routeName: (ctx) =>
                  const ForgetPasswordScreen(),
              CategoryProducts.routeName: (context) => const CategoryProducts()
            });
      }),
    );
  }
}
