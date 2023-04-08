import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_shopping_with_admin_panel/services/global_methods.dart';
import 'package:provider/provider.dart';

import 'package:grocery_shopping_with_admin_panel/provider/wishlist_provider.dart';

import '../services/utils.dart';

class HeartBTN extends StatelessWidget {
  final String productId;
  final bool? isInWishList;
  const HeartBTN({
    Key? key,
    required this.productId,
    this.isInWishList = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final wishListProvider = Provider.of<WishListProvider>(context);
    return GestureDetector(
      onTap: () {
        final User? user = FirebaseAuth.instance.currentUser;
        user != null
            ? GlobalMethods.errorDialog(
                subtitle: 'No user found, Please login first', context: context)
            : null;
        wishListProvider.addRemoveProductToWishList(productId: productId);
      },
      child: Icon(
        isInWishList != null && isInWishList == true
            ? IconlyBold.heart
            : IconlyLight.heart,
        size: 22.h,
        color:
            isInWishList != null && isInWishList == true ? Colors.red : color,
      ),
    );
  }
}
