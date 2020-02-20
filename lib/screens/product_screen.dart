import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_manager/blocs/products_bloc.dart';
import 'package:store_manager/validators/products_validator.dart';
import 'package:store_manager/widgets/images_widget.dart';

class ProductScreen extends StatefulWidget {
  final String categoryId;
  final DocumentSnapshot product;

  ProductScreen({this.categoryId, this.product});

  @override
  _ProductScreenState createState() => _ProductScreenState(categoryId, product);
}

class _ProductScreenState extends State<ProductScreen> with ProductsValidator {
  final ProductsBloc _productsBloc;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _ProductScreenState(String categoryId, DocumentSnapshot product)
      : _productsBloc = ProductsBloc(categoryId: categoryId, product: product);

  @override
  Widget build(BuildContext context) {
    InputDecoration _buildDecoration(String label) {
      return InputDecoration(
          labelText: label, labelStyle: TextStyle(color: Colors.grey));
    }

    final fieldStyle = TextStyle(color: Colors.white, fontSize: 16.0);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white12,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
        title: StreamBuilder<bool>(
            stream: _productsBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              return Text(snapshot.data ? 'Editar produto' : 'Criar produto');
            }),
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _productsBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data)
                return StreamBuilder<bool>(
                  stream: _productsBloc.outLoading,
                  initialData: false,
                  builder: (context, snapshot) {
                    return IconButton(
                        onPressed: snapshot.data ? null : (){
                          _productsBloc.deleteProduct();
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.delete_forever));
                  },
                );
              else
                return Container();
            },
          ),
          StreamBuilder<bool>(
              stream: _productsBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IconButton(
                    onPressed: snapshot.data ? null : saveProduct,
                    icon: Icon(Icons.save));
              }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: StreamBuilder<Map>(
                stream: _productsBloc.outData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return ListView(
                    padding: EdgeInsets.all(16.0),
                    children: <Widget>[
                      Text(
                        'Images',
                        style: TextStyle(color: Colors.white12),
                      ),
                      ImagesWidget(
                        context: context,
                        initialValue: snapshot.data['images'],
                        onSaved: _productsBloc.saveImages,
                        fieldValidator: validateImages,
                      ),
                      TextFormField(
                        initialValue: snapshot.data['title'],
                        style: fieldStyle,
                        decoration: _buildDecoration('Title'),
                        onSaved: _productsBloc.saveTitle,
                        validator: validateTitle,
                      ),
                      TextFormField(
                        initialValue: snapshot.data['description'],
                        style: fieldStyle,
                        maxLines: 6,
                        decoration: _buildDecoration('Description'),
                        onSaved: _productsBloc.saveDescription,
                        validator: validateDescription,
                      ),
                      TextFormField(
                        initialValue:
                            snapshot.data['price']?.toStringAsFixed(2),
                        style: fieldStyle,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: _buildDecoration('Price'),
                        onSaved: _productsBloc.savePrice,
                        validator: validatePrice,
                      ),
                    ],
                  );
                }),
          ),
          StreamBuilder<bool>(
              stream: _productsBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IgnorePointer(
                  ignoring: !snapshot.data,
                  child: Container(
                    color: snapshot.data ? Colors.black54 : Colors.transparent,
                  ),
                );
              }),
        ],
      ),
    );
  }

  Future<void> saveProduct() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.orangeAccent,
        content: Text(
          'Salvando prduto...',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 60),
      ));
      bool success = await _productsBloc.saveProduct();
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.orangeAccent,
        content: Text(
          success ? 'Produto salvo!' : 'Erro ao salvar produto!',
          style: TextStyle(color: Colors.white),
        ),
      ));
    }
  }
}
