import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../providers/auth.dart';

class ProductItem extends StatefulWidget {
  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  // final String id;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return GridTile(
      child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id!,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          )),
      // child: Image.network(
      //   product.imageUrl,
      //   fit: BoxFit.cover,
    );

    footer:
    ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTileBar(
        backgroundColor: Colors.black87,
        leading: Consumer<Product>(
          builder: (ctx, product, _) => IconButton(
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {
              product.toggleFavoriteStatus(
                authData.token,
                authData.userId!,
              );
            },
          ),
        ),
        // leading: IconButton(
        //   icon: Icon(
        //     product.isFavorite ? Icons.favorite : Icons.favorite_border,
        //   ),
        //   color: Theme.of(context).accentColor,
        //   onPressed: () {
        //     product.toggleFavoriteStatus();
        //     _toggleForm();

        //   },
        // ),
        //Consumer can be used to rebuild parts of the widget tree
        //instead of the entire widget tree
        // leading: Consumer<Product>(
        //   builder: (ctx, product, child) => IconButton(
        //     onPressed: () {
        //       product.toggleFavoritesStatus();
        //     },
        //     icon: Icon(
        //       product.isFavorite ? Icons.favorite : Icons.favorite_border,
        //     ),
        //     color: Theme.of(context).accentColor,
        //   ),
        //   //child value doesnot rebuild generally when you consumer rebuilds
        //   child: Text('Never Changes!'),
        // ),
        title: Text(
          product.title,
          textAlign: TextAlign.center,
        ),
        trailing: IconButton(
          onPressed: () {
            cart.addItem(product.id!, product.price, product.title);
            // If there is snackbar already this willbe hidden
            // before the new one is shown
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Added item to cart!',
              ),
              duration: Duration(seconds: 2),
              action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.removeSingleItem(product.id!);
                  }),
            ));
          },
          icon: Icon(Icons.shopping_cart),
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
