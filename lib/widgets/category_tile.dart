import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_manager/screens/product_screen.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot category;

  const CategoryTile({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(category.data['icon']),
            backgroundColor: Colors.transparent,
          ),
          title: Text(
            category.data['title'],
            style:
                TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w500),
          ),
          children: <Widget>[
            FutureBuilder<QuerySnapshot>(
              builder: (BuildContext context, snapshot) {
                if (!snapshot.hasData) return Container();
                return Column(
                  children: snapshot.data.documents.map((doc) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(doc.data['images'][0]),
                        backgroundColor: Colors.transparent,
                      ),
                      title: Text('${doc.data['title']}'),
                      trailing:
                          Text('R\$ ${doc.data['price'].toStringAsFixed(2)}'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductScreen(
                          categoryId: category.documentID,
                          product: doc,
                        )));
                      },
                    );
                  }).toList()
                    ..add(ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Icon(
                          Icons.add,
                          color: Colors.orangeAccent,
                        ),
                      ),
                      trailing: Text('Adicionar'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductScreen(
                          categoryId: category.documentID,
                        )));

                      },
                    )),
                );
              },
              future: category.reference.collection('items').getDocuments(),
            )
          ],
        ),
      ),
    );
  }
}
