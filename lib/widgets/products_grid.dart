import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import './product_item.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  final bool showfavs;

  ProductsGrid(this.showfavs);

  @override
  Widget build(BuildContext context) {
    //context => This sets up a direct communication channel behind
    //the scene
    final productsData = Provider.of<Products>(context);
    //With this piece of information we are telling
    //the provider package that we want to establish
    //a direct communication channel to the provided
    //instance of the product class

    final products = showfavs ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,

      //The item builder defines how every grid item is built
      //,how every grid cell should be built
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        //.value approach is the right approach you should use if you use
        //a provider on something that is a part of a list or a grid
        //because of the issue that widgets are recycled by the flutter
        //but the data attached to the widget changes
        //
        //If you have a builder function that would not work correctly here
        //it will work correctly because now the provider is tied to its data
        //and is attached and detached to and fro from the widget instead of
        //changing data being attached to the same provider
        // create: (c) => products[i],
        value: products[i],
        child: ProductItem(
            // products[i].id,
            //  products[i].title,
            //   products[i].imageUrl,
            ),
      ),

      //The grid delegate allow us to define how the grid
      //generally should be structured
      //So how many columns it should have most importantly
      //crossaxis=>column;
      // mainaxis=>row;
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //2 columns
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10, // spacing between columns
        mainAxisSpacing: 10, //space between the rows
      ),
    );
  }
}
