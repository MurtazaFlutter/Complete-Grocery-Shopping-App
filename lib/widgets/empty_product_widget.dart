import 'package:flutter/material.dart';
import 'package:grocery_shopping_with_admin_panel/services/utils.dart';

class EmptyProductWidget extends StatelessWidget {
  const EmptyProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).color;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Image.asset(
                'images/box.png',
              ),
            ),
            Text(
              'No products on sale yet!\nStay tuned',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: color, fontSize: 30, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
