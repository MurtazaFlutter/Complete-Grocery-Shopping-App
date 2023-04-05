import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_shopping_with_admin_panel/firebase_options.dart';
import 'package:grocery_shopping_with_admin_panel/provider/cart_provider.dart';
import 'package:grocery_shopping_with_admin_panel/provider/firebase_auth_provider.dart';
import 'package:grocery_shopping_with_admin_panel/provider/wishlist_provider.dart';
import 'package:provider/provider.dart';
import 'consts/theme_data.dart';
import 'inner_screens/category_products.dart';
import 'inner_screens/feeds_screen.dart';
import 'inner_screens/on_sale_screen.dart';
import 'inner_screens/product_details.dart';
import 'provider/dark_theme_provider.dart';
import 'provider/products_provider.dart';
import 'provider/viewed_provider_provider.dart';
import 'screens/auth/forget_pass.dart';
import 'screens/auth/login.dart';
import 'screens/auth/register.dart';
import 'screens/btm_bar.dart';
import 'screens/orders/orders_screen.dart';
import 'screens/viewed_recently/viewed_recently.dart';
import 'screens/wishlist/wishlist_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        }),
        ChangeNotifierProvider(create: (_) {
          return CartProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return WishListProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return ViewedModelProvider();
        }),
         ChangeNotifierProvider(create: (_) {
          return AuthProvider();
        })
      ],
      child:
          Consumer<DarkThemeProvider>(builder: (context, themeProvider, child) {
        return ScreenUtilInit(
          designSize: const Size(375, 835),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: Styles.themeData(themeProvider.getDarkTheme, context),
              home: const LoginScreen(),
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
                CategoryProducts.routeName: (context) =>
                    const CategoryProducts()
              }),
        );
      }),
    );
  }
}
