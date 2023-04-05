import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/products_model.dart';
import '../provider/products_provider.dart';
import '../services/utils.dart';
import '../widgets/back_widget.dart';
import '../widgets/empty_product_widget.dart';
import '../widgets/feed_items.dart';
import '../widgets/text_widget.dart';

class CategoryProducts extends StatefulWidget {
  static const routeName = "/CategoryProducts";
  const CategoryProducts({super.key});

  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
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
    final catName = ModalRoute.of(context)!.settings.arguments as String;
    List<ProductModel> allProductsByCategory =
        productsProvider.findByCategory(catName);
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: TextWidget(
          text: 'All Products',
          color: color,
          textSize: 20.0,
          isTitle: true,
        ),
      ),
      body: allProductsByCategory.isEmpty
          ? const EmptyProductWidget()
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: kBottomNavigationBarHeight,
                    child: TextField(
                      focusNode: _searchTextFocusNode,
                      controller: _searchTextController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Colors.greenAccent, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Colors.greenAccent, width: 1),
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
                            color: _searchTextFocusNode.hasFocus
                                ? Colors.red
                                : color,
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
                  childAspectRatio: size.width / (size.height * 0.59),
                  children:
                      List.generate(allProductsByCategory.length, (index) {
                    return ChangeNotifierProvider.value(
                      value: allProductsByCategory[index],
                      child: const FeedsWidget(),
                    );
                  }),
                ),
              ]),
            ),
    );
  }
}
