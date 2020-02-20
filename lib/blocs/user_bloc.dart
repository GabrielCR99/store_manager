import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase {
  final _usersController = BehaviorSubject<List>();

  Stream<List> get outUsers => _usersController.stream;

  Map<String, Map<String, dynamic>> _users = {};

  Firestore _firestore = Firestore.instance;

  UserBloc() {
    _addUsersListener();
  }

  Map<String, dynamic> getUser(String uid) => _users[uid];


  void _addUsersListener() {
    _firestore.collection('users').snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((changes) {
        String uid = changes.document.documentID;

        switch (changes.type) {
          case DocumentChangeType.added:
            _users[uid] = changes.document.data;
            _subscribeToOrders(uid);
            break;
          case DocumentChangeType.modified:
            _users[uid].addAll(changes.document.data);
            _usersController.add(_users.values.toList());

            break;
          case DocumentChangeType.removed:
            _users.remove(uid);
            _unsubscribeToOrders(uid);
            _usersController.add(_users.values.toList());

            break;
        }
      });
    });
  }

  void _subscribeToOrders(String uid) {
    _users[uid]['subscription'] = _firestore
        .collection('users')
        .document(uid)
        .collection('orders')
        .snapshots()
        .listen((orders) async {
      int numOrders = orders.documents.length;

      double money = 0.0;

      for (DocumentSnapshot d in orders.documents) {
        DocumentSnapshot order =
            await _firestore.collection('orders').document(d.documentID).get();

        if (order.data == null) continue;

        money += order.data['totalPrice'];
      }
      _users[uid].addAll({'money': money, 'orders': numOrders});
      _usersController.add(_users.values.toList());
    });
  }

  void _unsubscribeToOrders(String uid) {
    _users[uid]['subscription'].cancel();
  }

  void onChangedSearch(String search) {
    if (search.trim().isEmpty) {
      _usersController.add(_users.values.toList());
    } else {
      _usersController.add(_filter(search.trim()));
    }
  }

  List<Map<String, dynamic>> _filter(String search) {
    List<Map<String, dynamic>> _filteredUsers =
        List.from(_users.values.toList());
    _filteredUsers.retainWhere((userData) {
      return userData['name'].toUpperCase().contains(search.toUpperCase());
    });
    return _filteredUsers;
  }

  @override
  void dispose() {
    super.dispose();
    _usersController.close();
  }
}
