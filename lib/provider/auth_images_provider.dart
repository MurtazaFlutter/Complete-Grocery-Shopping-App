import 'package:flutter/material.dart';

class AuthImagesProvider with ChangeNotifier {
  final List<String> _authImagesPaths = [
    'images/landing/buy-on-laptop.jpg',
    'images/landing/buy-through.png',
    'images/landing/buyfood.jpg',
    'images/landing/grocery-cart.jpg',
    'images/landing/grocery-cart.jpg',
    'images/landing/store.jpg',
    'images/landing/vergtablebg.jpg',
  ];

  List<String> get authImages => _authImagesPaths;
}
