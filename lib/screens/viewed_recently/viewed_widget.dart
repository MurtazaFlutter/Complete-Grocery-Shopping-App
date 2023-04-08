import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_shopping_with_admin_panel/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import '../../inner_screens/product_details.dart';
import '../../models/viewed_products_model.dart';
import '../../provider/products_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/text_widget.dart';

class ViewedRecentlyWidget extends StatefulWidget {
  const ViewedRecentlyWidget({Key? key}) : super(key: key);

  @override
  _ViewedRecentlyWidgetState createState() => _ViewedRecentlyWidgetState();
}

class _ViewedRecentlyWidgetState extends State<ViewedRecentlyWidget> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final viewedProductsModel = Provider.of<ViewedProdcutsModel>(context);

    final getCurrentProduct =
        productProvider.findProductById(viewedProductsModel.productId);
    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;

    final cartProvider = Provider.of<CartProvider>(context);
    bool? isInCart =
        cartProvider.getCartItems.containsKey(getCurrentProduct.id);
    Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          // GlobalMethods.navigateTo(
          //     ctx: context, routeName: ProductDetails.routeName);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FancyShimmerImage(
              imageUrl: getCurrentProduct.imageUrl,
              boxFit: BoxFit.fill,
              height: size.width * 0.27,
              width: size.width * 0.25,
            ),
            SizedBox(
              width: 12.h,
            ),
            Column(
              children: [
                TextWidget(
                  text: getCurrentProduct.title,
                  color: color,
                  textSize: 24.h,
                  isTitle: true,
                ),
                SizedBox(
                  height: 12.h,
                ),
                TextWidget(
                  text: '\$${usedPrice.toStringAsFixed(2)}',
                  color: color,
                  textSize: 20.h,
                  isTitle: false,
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Material(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.green,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: isInCart
                        ? null
                        : () {
                            final User? user =
                                FirebaseAuth.instance.currentUser;
                            user != null
                                ? GlobalMethods.errorDialog(
                                    subtitle:
                                        'No user found, Please login first',
                                    context: context)
                                : null;
                            cartProvider.addProductsToCart(
                                productId: getCurrentProduct.id, quantity: 1);
                          },
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          isInCart ? Icons.check : IconlyBold.plus,
                          color: Colors.white,
                          size: 20.h,
                        )),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
