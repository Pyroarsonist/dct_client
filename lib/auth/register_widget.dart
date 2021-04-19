import 'package:dct_client/services/auth_service.dart';
import 'package:dct_client/services/token_service.dart';
import 'package:flutter/material.dart';

import '../logger.dart';
import '../routes.dart';
import '../utils.dart';
import 'dtos/register.dto.dart';

class RegisterWidget extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterWidget> {
  String email;
  String password;
  String name;
  DateTime birthDate;

  static const sizedBoxHeight = 30.0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime timePicked = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (timePicked != null && timePicked != birthDate) {
      setState(() {
        birthDate = timePicked;
      });
    }
  }

  Future<void> _register(BuildContext context) async {
    try {
      final dto =
          RegisterDto(email, password, name, birthDate.toIso8601String());

      final response = await AuthService.register(dto);

      if (!Utils.isStatusCodeOk(response.statusCode)) {
        //todo: make snackbar good
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to register',
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
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Repeat password',
                    hintText: 'Repeat your password'),
              ),
              const Divider(),
              TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                    hintText: 'Enter your name'),
                onChanged: (text) {
                  if (text != name) {
                    setState(() {
                      name = text;
                    });
                  }
                },
              ),
              const Divider(),

              // picker

              Text(
                birthDate == null
                    ? 'Pick date'
                    : '${birthDate.day}/${birthDate.month}/${birthDate.year}',
                style:
                    const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: sizedBoxHeight,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.lightBlueAccent)),
                onPressed: () => _selectDate(context),
                child: const Text(
                  'Select birth date',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),

              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.lightGreen)),
                onPressed: () => _register(context),
                child: const Text(
                  'Register',
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
