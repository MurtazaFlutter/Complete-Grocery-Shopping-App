import 'package:flutter/material.dart';
import 'package:grocery_shopping_with_admin_panel/models/cart_model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};

  Map<String, CartModel> get getCartItems => _cartItems;

  void addProductsToCart({
    required String productId,
    required int quantity,
  }) {
    _cartItems.putIfAbsent(
        productId,
        () => CartModel(
            id: DateTime.now().toString(),
            productId: productId,
            quantity: quantity));
    notifyListeners();
  }

  // decrease the quantity
  void reduceQuantityByOne({required String productId}) {
    _cartItems.update(
      productId,
      (value) => CartModel(
        id: value.id,
        productId: productId,
        quantity: value.quantity - 1,
      ),
    );
    notifyListeners();
  }

  // increase the quantity
  void increaseQuantityByOne({required String productId}) {
    _cartItems.update(
      productId,
      (value) => CartModel(
          id: value.id, productId: productId, quantity: value.quantity + 1),
    );
    notifyListeners();
  }

  // Remove One Item
  void removeOneItem({required String productId}) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  //Clear the cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
