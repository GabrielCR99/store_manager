import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:store_manager/blocs/user_bloc.dart';
import 'package:store_manager/widgets/user_tile.dart';

class UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.getBloc<UserBloc>();

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          child: TextField(
            onChanged: _userBloc.onChangedSearch,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.white),
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                border: InputBorder.none),
          ),
        ),
        Expanded(
          child: StreamBuilder<List>(
              stream: _userBloc.outUsers,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.red),
                    ),
                  );
                else if (snapshot.data.length == 0)
                  return Center(
                    child: Text(
                      'Nenhum usuário encontrado!',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                else
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        return UserTile(snapshot.data[index]);
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: snapshot.data.length);
              }),
        )
      ],
    );
  }
}
