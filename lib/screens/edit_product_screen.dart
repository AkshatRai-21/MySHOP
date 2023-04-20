import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

  // G L O B A L    KEY
  //So the global key will allow us to interact with the state behind
  //the form widget
  final _form = GlobalKey<FormState>();

  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();

    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // if you have a controller you can't set the initial
          //value instead then you set the controller to
          //it's initial value
          // 'imageUrl':_editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpg'))) {
        return;
      }

      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    //This will trigger all the validators
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id!, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error Occured!'),
            content: Text('Something went wrong'),
            // content: Text(error.toString()),
            //toString() on error objects are specifically configurred
            //to simply print a readable error message
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('Okay'),
              )
            ],
          ),
        );
      } //finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();

    //SaveForm will now trigger a method on every TextFormField which
    //allows you to take the value entered in TextFormField and do
    // whatever you want to do with it

    // Provider.of<Products>(context, listen: false).addProduct(_editedProduct);

    //This will go back to the previous page which shows all products
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },

                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }

                        return null;
                      },

                      //It takes the value that is currently entered into
                      //TextFormField and then you can do whatever you want
                      //with that value
                      onSaved: (value) {
                        //We have created new product here because we have
                        //initialized product parameters like id,title,
                        //with final which can't be changed after creating a
                        //new object ,so we are creating new product object
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: value!,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),

                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }

                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(value!),
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          description: value!,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),

                    //In form you are not restricted to just having TextFormField
                    //,you can use any widget you want ,form then just works
                    //together with TextFormField ,it ignores other widget
                    //therefore here we can add Row
                    Row(
                      children: [
                        Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(
                              top: 8,
                              right: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter a URL')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                      height: 2,
                                      width: 1.5,
                                    ),
                                  )),
                        // TextFormField by default takes as much width as it can
                        //get and the problem is that if that is inside a row,
                        //a row has an unconstrained width
                        //So normally the boundaries of the device width are the
                        //boundaries of the TextFormField but the Row doesnot have/
                        //take these boundaries ,it doesnot have the device width
                        //as an internal boundary so the TextFormField tries to take
                        //an infinte amount of width

                        //So to solve this issue we have wrapped up this
                        //TextFormField with Expaned Widget here
                        Expanded(
                          child: TextFormField(
                            // if you have a controller you can't set the initial
                            //value instead then you set the controller to
                            //it's initial value
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            //We have defined  a TextEditingController for this
                            //TextFormField because we want to get the imageUrl
                            //to display the preview
                            controller: _imageUrlController,
                            //To get the image preview when we loose
                            //focus from urlField
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (context) {
                              _saveForm();
                            },

                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an image URL.';
                              }

                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid image URL.';
                              }

                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please entr a valid image URL.';
                              }

                              return null;
                            },

                            onSaved: (value) {
                              _editedProduct = Product(
                                isFavorite: _editedProduct.isFavorite,
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: value!,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
