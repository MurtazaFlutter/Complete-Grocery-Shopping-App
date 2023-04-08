import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_shopping_with_admin_panel/provider/cart_provider.dart';
import 'package:grocery_shopping_with_admin_panel/provider/wishlist_provider.dart';
import 'package:grocery_shopping_with_admin_panel/services/global_methods.dart';
import 'package:provider/provider.dart';
import '../consts/auth_constans.dart';
import '../inner_screens/product_details.dart';
import '../models/products_model.dart';
import '../services/utils.dart';
import 'heart_btn.dart';
import 'price_widget.dart';
import 'text_widget.dart';

class OnSaleWidget extends StatelessWidget {
  const OnSaleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final Color color = Utils(context).color;
    bool? isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishListProvider = Provider.of<WishListProvider>(context);
    bool? isInWishList =
        wishListProvider.wishListItems.containsKey(productModel.id);

    return Padding(
      padding: EdgeInsets.all(8.0.r),
      child: Container(
        child: Material(
          color: Theme.of(context).cardColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 10.h),
            child: InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: () {
                // GlobalMethods.navigateTo(
                //     ctx: context, routeName: ProductDetails.routeName);
                Navigator.pushNamed(context, ProductDetails.routeName,
                    arguments: productModel.id);
              },
              child: Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Center(
                            child: CachedNetworkImage(
                              imageUrl: productModel.imageUrl,
                              height: 100.h,
                              width: 100.w,
                            ),
                          ),
                          Column(
                            children: [
                              TextWidget(
                                text: productModel.isPiece ? 'Piece' : 'KG',
                                color: color,
                                textSize: 18.h,
                                isTitle: true,
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: isInCart
                                        ? null
                                        : () {
                                            user == null
                                                ? GlobalMethods.errorDialog(
                                                    subtitle: 'subtitle',
                                                    context: context)
                                                : null;
                                            cartProvider.addProductsToCart(
                                                productId: productModel.id,
                                                quantity: 1);
                                          },
                                    child: Icon(
                                      isInCart
                                          ? IconlyBold.bag2
                                          : IconlyLight.bag2,
                                      size: 22.h,
                                      color: isInCart ? Colors.green : color,
                                    ),
                                  ),
                                  HeartBTN(
                                    productId: productModel.id,
                                    isInWishList: isInWishList,
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      PriceWidget(
                        salePrice: productModel.salePrice,
                        price: productModel.price,
                        textPrice: '1',
                        isOnSale: true,
                      ),
                      TextWidget(
                        text: productModel.title,
                        color: color,
                        textSize: 14.h,
                        isTitle: true,
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
