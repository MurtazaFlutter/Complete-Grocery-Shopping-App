import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_shopping_with_admin_panel/provider/cart_provider.dart';
import 'package:provider/provider.dart';
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

    return Padding(
      padding: EdgeInsets.all(8.0.r),
      child: Container(
        child: Material(
          color: Theme.of(context).cardColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: () {
              // GlobalMethods.navigateTo(
              //     ctx: context, routeName: ProductDetails.routeName);
              Navigator.pushNamed(context, ProductDetails.routeName,
                  arguments: productModel.id);
            },
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CachedNetworkImage(
                    imageUrl: productModel.imageUrl,
                    height: 150.h,
                    width: 150.w,
                  ),
                  Column(
                    children: [
                      TextWidget(
                        text: productModel.isPiece ? 'Piece' : 'KG',
                        color: color,
                        textSize: 22.h,
                        isTitle: true,
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              cartProvider.addProductsToCart(
                                  productId: productModel.id, quantity: 1);
                            },
                            child: Icon(
                              IconlyLight.bag2,
                              size: 22.h,
                              color: color,
                            ),
                          ),
                          const HeartBTN(),
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
                textSize: 16.h,
                isTitle: true,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
