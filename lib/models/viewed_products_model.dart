import 'package:flutter/material.dart';

class ViewedProdcutsModel with ChangeNotifier {
  final String id, productId;

  ViewedProdcutsModel({
    required this.id,
    required this.productId,
  });
}
