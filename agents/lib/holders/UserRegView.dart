import 'package:agents/models/Users.dart';
import 'package:flutter/material.dart';

class UsersRegListItem extends StatefulWidget {
  User user;


  UsersRegListItem(this.user);

  @override
  _UsersRegListItemState createState() => _UsersRegListItemState();
}

class _UsersRegListItemState extends State<UsersRegListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))),
          child: ListTile(
            title: Text(widget.user.phoneNumber),
            subtitle: Text(widget.user.Profile),
            trailing: Text(widget.user.CountyName),
          ),
        )
    );
  }
}
