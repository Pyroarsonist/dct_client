import 'package:dct_client/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'dtos/login.dto.dart';

import '../main.dart';
import '../utils.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginWidget> {
  String email;
  String password;

  static const SIZED_BOX_HEIGHT = 30.0;

  _login(BuildContext context) async {
    try {
      var dto = new LoginDto(
        email,
        password,
      );

      final response = await AuthService.login(dto);
      if (!Utils.isStatusCodeOk(response.statusCode)) {
        //todo: make snackbar good
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to login',
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MyApp(true);
      }));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //todo: make own logo
              FlutterLogo(
                size: 200,
              ),
              SizedBox(height: SIZED_BOX_HEIGHT),
              TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter your email'),
                  onChanged: (text) {
                    if (text != email) {
                      this.setState(() {
                        email = text;
                      });
                    }
                  }),
              Divider(),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter your password'),
                onChanged: (text) {
                  if (text != password) {
                    this.setState(() {
                      password = text;
                    });
                  }
                },
              ),
              Divider(),

              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue)),
                onPressed: () => _login(context),
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
