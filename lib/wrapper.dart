import 'package:cookit/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authenticate.dart';
import 'models/User.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return user == null ? Authenticate() : Home(user: user);
  }
}
