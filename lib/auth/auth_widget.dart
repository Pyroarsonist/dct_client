import 'package:dct_client/auth/login_widget.dart';
import 'package:dct_client/auth/register_widget.dart';
import 'package:flutter/material.dart';

class AuthWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lime,
        body: Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 300, horizontal: 0),
              child: Column(
                children: [
                  Icon(
                    Icons.traffic_sharp,
                    size: 40,
                    color: Colors.blueGrey,
                  ),
                  Text(
                    'Dangerous crowds tracker',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  ElevatedButton(
                    child: Text('Login'),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LoginWidget();
                    })),
                  ),
                  ElevatedButton(
                    child: Text('Register'),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RegisterWidget();
                    })),
                  ),
                ],
              ),
            )));
  }
}
