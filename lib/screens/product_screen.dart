import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_manager/blocs/products_bloc.dart';
import 'package:store_manager/widgets/images_widget.dart';

class ProductScreen extends StatefulWidget {
  final String categoryId;
  final DocumentSnapshot product;

  ProductScreen({this.categoryId, this.product});

  @override
  _ProductScreenState createState() => _ProductScreenState(categoryId, product);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductsBloc _productsBloc;

  final _formKey = GlobalKey<FormState>();

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
      backgroundColor: Colors.white12,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
        title: Text('Criar produto'),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: Icon(Icons.remove)),
          IconButton(onPressed: () {}, icon: Icon(Icons.save))
        ],
      ),
      body: Form(
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
                    onSaved: (l) {},
                    fieldValidator: (l) {},
                  ),
                  TextFormField(
                    initialValue: snapshot.data['title'],
                    style: fieldStyle,
                    decoration: _buildDecoration('Title'),
                    onSaved: (t) {},
                    validator: (t) {},
                  ),
                  TextFormField(
                    initialValue: snapshot.data['description'],
                    style: fieldStyle,
                    maxLines: 6,
                    decoration: _buildDecoration('Description'),
                    onSaved: (t) {},
                    validator: (t) {},
                  ),
                  TextFormField(
                    initialValue: snapshot.data['price']?.toStringAsFixed(2),
                    style: fieldStyle,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: _buildDecoration('Price'),
                    onSaved: (t) {},
                    validator: (t) {},
                  ),
                ],
              );
            }),
      ),
    );
  }
}
