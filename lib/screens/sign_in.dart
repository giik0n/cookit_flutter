import 'package:cookit/services/auth.dart';
import 'package:flutter/material.dart';

import 'loading.dart';

class SighIn extends StatefulWidget {
  final Function toggleView;

  SighIn({this.toggleView});
  @override
  _SighInState createState() => _SighInState();
}

class _SighInState extends State<SighIn> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool loading = false;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  //text fields state
  String email = "";
  String password = "";
  String error = "";
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: Text('Sign in'),
              actions: <Widget>[
                FlatButton.icon(
                  onPressed: () {
                    widget.toggleView();
                  },
                  icon: Icon(
                    Icons.person_add,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Register",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Image.asset('assets/images/logo.png'),
                        Container(
                          child: Center(
                            child: Text(
                              "Cook It",
                              style: TextStyle(
                                  color: Colors.orangeAccent, fontSize: 64),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            AutofillGroup(
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: [AutofillHints.email],
                                textInputAction: TextInputAction.next,
                                decoration: new InputDecoration(
                                    hintText: 'Email',
                                    icon: const Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: const Icon(Icons.person))),
                                validator: (val) =>
                                    val.isEmpty ? 'Enter an email' : null,
                                onChanged: (val) {
                                  setState(() {
                                    email = val;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            AutofillGroup(
                              child: TextFormField(
                                autofillHints: [AutofillHints.password],
                                textInputAction: TextInputAction.done,
                                decoration: new InputDecoration(
                                  hintText: 'Password',
                                  icon: const Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: const Icon(Icons.lock),
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      _toggle();
                                    },
                                    child: Icon(
                                      _obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                ),
                                validator: (val) => val.length < 6
                                    ? 'Enter a password 6+ chars long'
                                    : null,
                                obscureText: _obscureText,
                                onChanged: (val) {
                                  setState(() {
                                    password = val;
                                  });
                                },
                                onFieldSubmitted: (String str) async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    dynamic result = await _authService
                                        .signInWithEmailAndPassword(
                                            email.trim(), password);
                                    if (result == null) {
                                      setState(() {
                                        loading = false;
                                        error = "Cant sign in";
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        RaisedButton(
                          //color: Colors.white,
                          child: Text(
                            'Sign in',
                            // style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result =
                                  await _authService.signInWithEmailAndPassword(
                                      email.trim(), password);
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error = "Cant sign in";
                                });
                              }
                            } // if validation
                          },
                        ),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
