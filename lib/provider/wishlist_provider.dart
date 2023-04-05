import 'package:flutter/material.dart';
import '../models/wish_list_model.dart';

class WishListProvider with ChangeNotifier {
  final Map<String, WishListModel> _wishListItems = {};

  Map<String, WishListModel> get wishListItems => _wishListItems;

  void addRemoveProductToWishList({required String productId}) {
    _wishListItems.containsKey(productId)
        ? removeOneItem(productId)
        : _wishListItems.putIfAbsent(
            productId,
            () => WishListModel(
              id: DateTime.now().toString(),
              productId: productId,
            ),
          );
    notifyListeners();
  }

  void removeOneItem(String productId) {
    _wishListItems.remove(productId);
    notifyListeners();
  }

  void clearWishList() {
    _wishListItems.clear();
    notifyListeners();
  }
}
