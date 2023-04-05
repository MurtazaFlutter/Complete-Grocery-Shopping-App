import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../../provider/wishlist_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';
import 'wishlist_widget.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = "/WishlistScreen";
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;

    final wishListProvider = Provider.of<WishListProvider>(context);
    final wishListItemList =
        wishListProvider.wishListItems.values.toList().reversed.toList();

    return wishListItemList.isEmpty
        ? const EmptyScreen(
            imagePath: 'images/wishlist.png',
            title: 'Your WishList is Empty',
            subtitle: 'Explore more and shortlist some items',
            buttonText: 'Add a WishList')
        : Scaffold(
            appBar: AppBar(
                centerTitle: true,
                leading: const BackWidget(),
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: TextWidget(
                  text: 'Wishlist (${wishListItemList.length})',
                  color: color,
                  isTitle: true,
                  textSize: 22,
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      GlobalMethods.warningDialog(
                          title: 'Empty your wishlist?',
                          subtitle: 'Are you sure?',
                          fct: () {
                            wishListProvider.clearWishList();
                            Navigator.pop(context);
                          },
                          context: context);
                    },
                    icon: Icon(
                      IconlyBroken.delete,
                      color: color,
                    ),
                  ),
                ]),
            body: MasonryGridView.count(
              itemCount: wishListItemList.length,
              crossAxisCount: 2,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                    value: wishListItemList[index],
                    child: const WishlistWidget());
              },
            ));
  }
}
