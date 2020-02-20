import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store_manager/validators/login_validator.dart';

enum LoginState { IDLE, LOADING, SUCCESS, FAIL }

class LoginBloc extends BlocBase with LoginValidators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<LoginState>();

  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);

  Stream<String> get outPassword =>
      _passwordController.stream.transform(validatePassword);

  Stream<bool> get isOutSubmitValid =>
      Observable.combineLatest2(outEmail, outPassword, (a, b) => true);

  Stream<LoginState> get outState => _stateController.stream;

  Function(String) get changedEmail => _emailController.sink.add;

  Function(String) get changedPassword => _passwordController.sink.add;

  StreamSubscription _subscription;

  LoginBloc() {
    _subscription =
        FirebaseAuth.instance.onAuthStateChanged.listen((user) async {
      if (user != null) {
        if (await checkPrivileges(user))
          _stateController.add(LoginState.SUCCESS);
        else {
          FirebaseAuth.instance.signOut();
          _stateController.add(LoginState.FAIL);
        }
      } else {
        _stateController.add(LoginState.IDLE);
      }
    });
  }

  void submit() async {
    final email = _emailController.value;
    final password = _passwordController.value;

    _stateController.add(LoginState.LOADING);

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError(() {
      _stateController.add(LoginState.FAIL);
    });
  }

  Future<bool> checkPrivileges(FirebaseUser user) async {
    return await Firestore.instance
        .collection('admins')
        .document(user.uid)
        .get()
        .then((doc) {
      if(doc.data != null)
        return true;
      else
        return false;
    }).catchError((e) {
      return false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.close();
    _passwordController.close();
    _stateController.close();
    _subscription.cancel();
  }
}
