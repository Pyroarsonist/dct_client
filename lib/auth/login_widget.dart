import 'package:dct_client/services/auth_service.dart';
import 'package:dct_client/services/token_service.dart';
import 'package:flutter/material.dart';

import '../logger.dart';
import '../routes.dart';
import '../utils.dart';
import 'dtos/login.dto.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginWidget> {
  String email;
  String password;

  static const sizedBoxHeight = 30.0;

  Future<void> _login(BuildContext context) async {
    try {
      final dto = LoginDto(
        email,
        password,
      );

      final response = await AuthService.login(dto);
      if (!Utils.isStatusCodeOk(response.statusCode)) {
        //todo: make snackbar good
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to login',
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
        return;
      }

      await TokenService.saveToken(response.body);

      Navigator.pushReplacementNamed(context, homeRoute);

    } catch (e) {
      logger.e(e);
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
              const FlutterLogo(
                size: 200,
              ),
              const SizedBox(height: sizedBoxHeight),
              TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter your email'),
                  onChanged: (text) {
                    if (text != email) {
                      setState(() {
                        email = text;
                      });
                    }
                  }),
              const Divider(),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter your password'),
                onChanged: (text) {
                  if (text != password) {
                    setState(() {
                      password = text;
                    });
                  }
                },
              ),
              const Divider(),

              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue)),
                onPressed: () => _login(context),
                child: const Text(
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
