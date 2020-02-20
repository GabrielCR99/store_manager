import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'order_header.dart';

class OrderTile extends StatelessWidget {
  final DocumentSnapshot order;
  final status = [
    '',
    'Em preparação',
    'Em transporte',
    'Aguardando entrega',
    'Entregue'
  ];

  OrderTile(this.order);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Card(
        child: ExpansionTile(
          initiallyExpanded: order.data['status'] != 4,
          key: Key(order.documentID),
          title: Text(
            '#${order.documentID.substring(order.documentID.length - 7, order.documentID.length)} - ${status[order.data['status']]}',
            style: TextStyle(
                color: order.data['status'] != 4
                    ? Colors.grey[800]
                    : Colors.green),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 0, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  OrderHeader(order),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: order.data['products'].map<Widget>((p) {
                          return ListTile(
                            title: Text(
                                p['product']['title'] + ' ' + p['size'] ?? ''),
                            subtitle: Text('${p['category']}' ?? ''),
                            trailing: Text(
                              p['qty'].toString() ?? '',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            contentPadding: EdgeInsets.zero,
                          );
                        }).toList() ??
                        [],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Firestore.instance
                              .collection('users')
                              .document(order['clientId'])
                              .collection('orders')
                              .document(order.documentID)
                              .delete();
                          order.reference.delete();
                        },
                        child: Text('Excluir'),
                        textColor: Colors.red,
                      ),
                      FlatButton(
                        onPressed: order.data['status'] > 1
                            ? () {
                                order.reference.updateData(
                                    {'status': order.data['status'] - 1});
                              }
                            : null,
                        child: Text('Regredir status'),
                        textColor: Colors.grey[800],
                      ),
                      FlatButton(
                        onPressed: order.data['status'] < 4
                            ? () {
                                order.reference.updateData(
                                    {'status': order.data['status'] + 1});
                              }
                            : null,
                        child: Text('Avançar'),
                        textColor: Colors.green,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
