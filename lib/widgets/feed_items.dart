import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_shopping_with_admin_panel/models/products_model.dart';
import 'package:grocery_shopping_with_admin_panel/provider/cart_provider.dart';
import 'package:grocery_shopping_with_admin_panel/provider/wishlist_provider.dart';
import 'package:provider/provider.dart';

import '../consts/auth_constans.dart';
import '../inner_screens/product_details.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';
import 'heart_btn.dart';
import 'price_widget.dart';
import 'text_widget.dart';

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final products = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    bool isInCart = cartProvider.getCartItems.containsKey(products.id);
    final wishListProvider = Provider.of<WishListProvider>(context);
    final bool isInWishList =
        wishListProvider.wishListItems.containsKey(products.id);

    return Padding(
      padding: EdgeInsets.all(8.0.r),
      child: Material(
        borderRadius: BorderRadius.circular(12.r),
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () {
            // GlobalMethods.navigateTo(
            //     ctx: context, routeName: ProductDetails.routeName);
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: products.id);
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Column(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CachedNetworkImage(
                  imageUrl: products.imageUrl,
                  height: 90.h,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      const Icon(IconlyLight.lock),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextWidget(
                          text: products.title,
                          color: color,
                          textSize: 15.h,
                          isTitle: true,
                        ),
                      ),
                      HeartBTN(
                        productId: products.id,
                        isInWishList: isInWishList,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 4,
                        child: PriceWidget(
                          salePrice: products.salePrice,
                          price: products.price,
                          textPrice: _quantityTextController.text,
                          isOnSale: products.isOnSale,
                        ),
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      Flexible(
                        child: Row(
                          children: [
                            Flexible(
                              // flex: 4,
                              child: FittedBox(
                                child: TextWidget(
                                  text: products.isPiece ? 'Piece' : 'KG',
                                  color: color,
                                  textSize: 18.h,
                                  isTitle: true,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Flexible(
                                //  flex: 2,
                                // TextField can be used also instead of the textFormField
                                child: TextFormField(
                              controller: _quantityTextController,
                              key: const ValueKey('10'),
                              style: TextStyle(color: color, fontSize: 18.h),
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              enabled: true,
                              onChanged: (valueee) {
                                setState(() {});
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.]'),
                                ),
                              ],
                            ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        user != null
                            ? GlobalMethods.errorDialog(
                                subtitle: 'No user found, Please login first',
                                context: context)
                            : print(user!.uid);
                        isInCart
                            ? null
                            : cartProvider.addProductsToCart(
                                productId: products.id,
                                quantity:
                                    int.parse(_quantityTextController.text));
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).cardColor),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12.0.r),
                                bottomRight: Radius.circular(12.0.r),
                              ),
                            ),
                          )),
                      child: TextWidget(
                        text: isInCart ? "In Cart" : 'Add to cart',
                        maxLines: 1,
                        color: color,
                        textSize: 18.h,
                      ),
                    ),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
