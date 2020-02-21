import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:store_manager/blocs/orders_bloc.dart';
import 'package:store_manager/blocs/user_bloc.dart';
import 'package:store_manager/tabs/orders_tab.dart';
import 'package:store_manager/tabs/products_tab.dart';
import 'package:store_manager/tabs/users_tab.dart';
import 'package:store_manager/widgets/edit_category_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int page = 0;
  UserBloc _userBloc;
  OrdersBloc _ordersBloc;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _userBloc = UserBloc();
    _ordersBloc = OrdersBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      bottomNavigationBar: Theme(
        child: BottomNavigationBar(
          currentIndex: page,
          onTap: (p) {
            _pageController.animateToPage(p,
                duration: Duration(milliseconds: 500), curve: Curves.easeIn);
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              title: Text('Clientes'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text('Pedidos'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text('Produtos'),
            ),
          ],
        ),
        data: Theme.of(context).copyWith(
          canvasColor: Colors.orangeAccent,
          primaryColor: Colors.white,
          textTheme: Theme.of(context)
              .textTheme
              .copyWith(caption: TextStyle(color: Colors.white)),
        ),
      ),
      body: SafeArea(
        child: BlocProvider(
          blocs: [
            Bloc((i) => _userBloc),
            Bloc((i) => _ordersBloc),
          ],
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (p) {
              setState(() {
                page = p;
              });
            },
            controller: _pageController,
            children: <Widget>[
              UsersTab(),
              OrdersTab(),
              ProductsTab(),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloating(),
    );
  }

  Widget _buildFloating() {
    switch (page) {
      case 0:
        return null;
      case 1:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Colors.orangeAccent,
          overlayOpacity: 0.5,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
                child: Icon(Icons.arrow_downward, color: Colors.orangeAccent),
                backgroundColor: Colors.white,
                label: 'Concluídos abaixo',
                labelStyle: TextStyle(fontSize: 16.0),
                onTap: () {
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_LAST);
                }),
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.orangeAccent,
                ),
                backgroundColor: Colors.white,
                label: 'Concluídos acima',
                labelStyle: TextStyle(fontSize: 16.0),
                onTap: () {
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_FIRST);
                }),
          ],
        );
      case 2:
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.orangeAccent,
          onPressed: () {
            showDialog(
                context: context, builder: (context) => EditCategoryDialog());
          },
        );
    }
    return null;
  }
}
