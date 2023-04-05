import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_shopping_with_admin_panel/models/wish_list_model.dart';
import 'package:grocery_shopping_with_admin_panel/provider/products_provider.dart';
import 'package:grocery_shopping_with_admin_panel/provider/wishlist_provider.dart';
import 'package:provider/provider.dart';
import '../../inner_screens/product_details.dart';
import '../../services/utils.dart';
import '../../widgets/heart_btn.dart';
import '../../widgets/text_widget.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final productProvider = Provider.of<ProductsProvider>(context);
    final wishListModel = Provider.of<WishListModel>(context);
    final wishListProvider = Provider.of<WishListProvider>(context);

    final getCurrentProduct =
        productProvider.findProductById(wishListModel.productId);
    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    bool isInWishList =
        wishListProvider.wishListItems.containsKey(getCurrentProduct.id);

    return Padding(
      padding: EdgeInsets.all(10.0.r),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ProductDetails.routeName,
              arguments: wishListModel.productId);
        },
        child: Container(
          height: 250.h,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: color, width: 1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FancyShimmerImage(
                    imageUrl: getCurrentProduct.imageUrl,
                    boxFit: BoxFit.fill,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        IconlyLight.bag2,
                        color: color,
                      ),
                    ),
                    HeartBTN(
                      productId: getCurrentProduct.id,
                      isInWishList: isInWishList,
                    ),
                  ],
                ),
                TextWidget(
                  text: getCurrentProduct.title,
                  color: color,
                  textSize: 20.0.h,
                  maxLines: 2,
                  isTitle: true,
                ),
                SizedBox(
                  height: 5.h,
                ),
                TextWidget(
                  text: '\$${usedPrice.toStringAsFixed(2)}',
                  color: color,
                  textSize: 18.0.h,
                  maxLines: 1,
                  isTitle: true,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
