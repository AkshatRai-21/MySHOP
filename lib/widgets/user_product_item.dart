import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products.dart';
import '../providers/product.dart';

class UserProductItem extends StatelessWidget {
  final String? id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id!);
                } catch (error) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text('Deleting failed!')),
                  // );

                  //Basically the problem here with ScaffoldMessenger.of(context)
                  //is here we are doing it inside of a future because async
                  //is used and therefore everything is wrapped inside future
                  //therefore of(context) can't be resolved anymore due to
                  //how flutter works internally
                  //
                  //It's already updating widget tree at this point of time and
                  //here it is not sure that the context refers to the same
                  //context as it was referring to before

                  scaffold.showSnackBar(
                    SnackBar(
                        content: Text(
                      'Deleting failed!',
                      textAlign: TextAlign.center,
                    )),
                  );
                }
              },
              icon: Icon(Icons.delete),
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
