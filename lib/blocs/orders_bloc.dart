import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

enum SortCriteria { READY_FIRST, READY_LAST }

class OrdersBloc extends BlocBase {
  final _ordersController = BehaviorSubject<List>();

  List<DocumentSnapshot> _orders = [];

  SortCriteria _criteria;

  Stream<List> get outOrders => _ordersController.stream;

  Firestore _firestore = Firestore.instance;

  OrdersBloc() {
    _addOrdersListeners();
  }

  void _addOrdersListeners() {
    _firestore.collection('orders').snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((changes) {
        String orderId = changes.document.documentID;

        switch (changes.type) {
          case DocumentChangeType.added:
            _orders.add(changes.document);
            break;
          case DocumentChangeType.modified:
            _orders.removeWhere((order) => order.documentID == orderId);
            _orders.add(changes.document);
            break;
          case DocumentChangeType.removed:
            _orders.removeWhere((order) => order.documentID == orderId);
            break;
        }
      });
      _sort();
    });
  }

  void setOrderCriteria(SortCriteria criteria) {
    _criteria = criteria;
    _sort();
  }

  @override
  void dispose() {
    super.dispose();
    _ordersController.close();
  }

  void _sort() {
    switch (_criteria) {
      case SortCriteria.READY_FIRST:
        _orders.sort((a, b) {
          int statusA = a.data['status'];
          int statusB = b.data['status'];

          if (statusA < statusB) return 1;
          if (statusA > statusB)
            return -1;
          else
            return 0;
        });
        break;
      case SortCriteria.READY_LAST:
        _orders.sort((a, b) {
          int statusA = a.data['status'];
          int statusB = b.data['status'];

          if (statusA > statusB) return 1;
          if (statusA < statusB)
            return -1;
          else
            return 0;
        });
        break;
    }
    _ordersController.add(_orders);

  }
}
