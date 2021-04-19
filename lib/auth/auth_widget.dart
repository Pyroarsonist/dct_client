import 'package:flutter/material.dart';

import '../routes.dart';

class AuthWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lime,
        body: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 300),
              child: Column(
                children: [
                  const Icon(
                    Icons.traffic_sharp,
                    size: 40,
                    color: Colors.blueGrey,
                  ),
                  Text(
                    'Dangerous crowds tracker',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, loginRoute),
                    child: const Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, registerRoute),
                    child: const Text('Register'),
                  ),
                ],
              ),
            )));
  }
}
