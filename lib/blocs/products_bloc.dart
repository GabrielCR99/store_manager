import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ProductsBloc extends BlocBase {
  final _dataController = BehaviorSubject<Map>();

  Stream<Map> get outData => _dataController.stream;

  DocumentSnapshot product;
  String categoryId;

  Map<String, dynamic> unsavedData;

  ProductsBloc({this.product, this.categoryId}) {
    if (product != null) {
      unsavedData = Map.of(product.data);
      unsavedData['images'] = List.of(product.data['images']);
      unsavedData['sizes'] = List.of(product.data['sizes']);
    }else{
      unsavedData = {
        'title': null,
        'description': null,
        'price': null,
        'images': [],
        'sizes': [],
      };
    }
    _dataController.add(unsavedData);
  }

  @override
  void dispose() {
    super.dispose();
    _dataController.close();
  }
}
