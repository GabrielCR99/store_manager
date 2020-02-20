import 'package:flutter/material.dart';
import 'package:store_manager/blocs/login_bloc.dart';
import 'package:store_manager/widgets/input_field.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();
    _loginBloc.outState.listen((state) {
      switch (state) {
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
          break;
        case LoginState.FAIL:
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('Error'),
                    content: Text('Sem privilégios necessários!'),
                  ));
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      body: StreamBuilder<LoginState>(
        initialData: LoginState.LOADING,
        stream: _loginBloc.outState,
        builder: (context, snapshot) {
          print(snapshot.data);
          switch (snapshot.data) {
            case LoginState.LOADING:
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.orangeAccent),
                ),
              );
              break;
            case LoginState.IDLE:
            case LoginState.SUCCESS:
            case LoginState.FAIL:
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(),
                  SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Image.asset(
                            'images/login_image.png',
                            height: 160,
                            width: 160,
                          ),
                          InputField(
                            iconData: Icons.person,
                            hint: 'Usuário',
                            isObscure: false,
                            stream: _loginBloc.outEmail,
                            onChanged: _loginBloc.changedEmail,
                          ),
                          InputField(
                            iconData: Icons.lock,
                            hint: 'Senha',
                            isObscure: true,
                            stream: _loginBloc.outPassword,
                            onChanged: _loginBloc.changedPassword,
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          StreamBuilder<bool>(
                              stream: _loginBloc.isOutSubmitValid,
                              builder: (context, snapshot) {
                                return SizedBox(
                                  height: 45.0,
                                  child: RaisedButton(
                                    disabledColor:
                                        Colors.orangeAccent.withAlpha(100),
                                    color: Colors.orange,
                                    child: Text('Entrar'),
                                    onPressed: snapshot.hasData
                                        ? _loginBloc.submit
                                        : null,
                                    textColor: Colors.white,
                                  ),
                                );
                              })
                        ],
                      ),
                    ),
                  ),
                ],
              );
              break;
          }
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _loginBloc.dispose();
  }
}
