import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_shopping_with_admin_panel/models/products_model.dart';
import 'package:grocery_shopping_with_admin_panel/provider/products_provider.dart';
import 'package:provider/provider.dart';
import '../services/utils.dart';
import '../widgets/back_widget.dart';
import '../widgets/feed_items.dart';
import '../widgets/text_widget.dart';

class FeedsScreen extends StatefulWidget {
  static const routeName = "/FeedsScreenState";
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  @override
  void dispose() {
    _searchTextController.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productsProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productsProvider.getProducts;
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: TextWidget(
          text: 'All Products',
          color: color,
          textSize: 20.0.h,
          isTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(8.0.r),
            child: SizedBox(
              height: kBottomNavigationBarHeight,
              child: TextField(
                focusNode: _searchTextFocusNode,
                controller: _searchTextController,
                onChanged: (valuee) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide:
                        BorderSide(color: Colors.greenAccent, width: 1.w),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide:
                        const BorderSide(color: Colors.greenAccent, width: 1),
                  ),
                  hintText: "What's in your mind",
                  prefixIcon: const Icon(Icons.search),
                  suffix: IconButton(
                    onPressed: () {
                      _searchTextController.clear();
                      _searchTextFocusNode.unfocus();
                    },
                    icon: Icon(
                      Icons.close,
                      color: _searchTextFocusNode.hasFocus ? Colors.red : color,
                    ),
                  ),
                ),
              ),
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            padding: EdgeInsets.zero,
            // crossAxisSpacing: 10,
            childAspectRatio: size.width / (size.height * 0.59),
            children: List.generate(allProducts.length, (index) {
              return ChangeNotifierProvider.value(
                value: allProducts[index],
                child: const FeedsWidget(),
              );
            }),
          ),
        ]),
      ),
    );
  }
}
