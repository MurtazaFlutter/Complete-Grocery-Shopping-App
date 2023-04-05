import 'package:flutter/material.dart';
import 'package:grocery_shopping_with_admin_panel/models/viewed_products_model.dart';

class ViewedModelProvider with ChangeNotifier {
  final Map<String, ViewedProdcutsModel> _viewedProductsItems = {};

  Map<String, ViewedProdcutsModel> get viewProductsItems =>
      _viewedProductsItems;

  void addProductsToHistory({required String productId}) {
    _viewedProductsItems.putIfAbsent(
      productId,
      () => ViewedProdcutsModel(
          id: DateTime.now().toString(), productId: productId),
    );
    notifyListeners();
  }

  void clearHistory() {
    _viewedProductsItems.clear();
    notifyListeners();
  }
}
