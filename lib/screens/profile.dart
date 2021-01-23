import 'package:cookit/services/auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Spacer(),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                onPressed: () {
                  AuthService().signOut();
                },
                child: Text(
                  "Log out",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
