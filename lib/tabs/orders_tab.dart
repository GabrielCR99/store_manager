import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:store_manager/blocs/orders_bloc.dart';
import 'package:store_manager/widgets/order_tile.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _ordersBloc = BlocProvider.getBloc<OrdersBloc>();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: StreamBuilder<List>(
          stream: _ordersBloc.outOrders,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.red),
                ),
              );
            } else if (snapshot.data.isEmpty)
              return Center(
                child: Text(
                  'Nenhum pedido encontrado!',
                  style: TextStyle(color: Colors.red),
                ),
              );
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return OrderTile(snapshot.data[index]);
                });
          }),
    );
  }
}
