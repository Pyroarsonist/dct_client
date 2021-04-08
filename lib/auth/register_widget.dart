import 'package:dct_client/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'dtos/register.dto.dart';
import '../main.dart';
import '../utils.dart';

class RegisterWidget extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterWidget> {
  String email;
  String password;
  String name;
  DateTime birthDate;

  static const SIZED_BOX_HEIGHT = 30.0;

  _selectDate(BuildContext context) async {
    final DateTime timePicked = await showDatePicker(
      context: context,
      initialDate: birthDate == null ? DateTime.now() : birthDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (timePicked != null && timePicked != birthDate)
      setState(() {
        birthDate = timePicked;
      });
  }

  _register(BuildContext context) async {
    try {
      var dto =
          new RegisterDto(email, password, name, birthDate.toIso8601String());

      final response = await AuthService.register(dto);

      if (!Utils.isStatusCodeOk(response.statusCode)) {
        //todo: make snackbar good
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to register',
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
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Repeat password',
                    hintText: 'Repeat your password'),
              ),
              Divider(),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                    hintText: 'Enter your name'),
                onChanged: (text) {
                  if (text != name) {
                    this.setState(() {
                      name = text;
                    });
                  }
                },
              ),
              Divider(),

              // picker

              Text(
                birthDate == null
                    ? "Pick date"
                    : "${birthDate.day}/${birthDate.month}/${birthDate.year}",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: SIZED_BOX_HEIGHT,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.lightBlueAccent)),
                onPressed: () => _selectDate(context),
                child: Text(
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
                child: Text(
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
