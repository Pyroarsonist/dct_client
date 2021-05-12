import 'package:dct_client/profile/enums/sex_enum.dart';
import 'package:dct_client/services/auth_service.dart';
import 'package:dct_client/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../logger.dart';
import '../routes.dart';
import '../utils.dart';
import 'dtos/register.dto.dart';

class RegisterWidget extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  DateTime _birthDate;
  Sex _sex;
  bool _passwordVisible = false;
  bool _repeatedPasswordVisible = false;

  static const sizedBoxHeight = 30.0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    const maxHumanLifeInYears = 150;
    final DateTime timePicked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - maxHumanLifeInYears),
      lastDate: DateTime.now(),
    );
    if (timePicked != null && timePicked != _birthDate) {
      setState(() {
        _birthDate = timePicked;
      });
    }
  }

  Future<void> _register(BuildContext context) async {
    try {
      if (!_formKey.currentState.validate()) {
        return;
      }

      final dto = RegisterDto(_nameController.text, _emailController.text,
          _passwordController.text, _birthDate.toIso8601String(), _sex);

      final response = await AuthService.register(dto);

      if (!Utils.isStatusCodeOk(response.statusCode)) {
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Try again later',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView(
              children: [
                //todo: make own logo
                const FlutterLogo(
                  size: 200,
                ),
                const SizedBox(height: sizedBoxHeight),
                TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter your email'),
                  autofocus: true,
                  controller: _emailController,
                  validator: EmailValidator(errorText: 'Invalid email'),
                ),
                const Divider(),
                TextFormField(
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  controller: _passwordController,
                  validator: RequiredValidator(errorText: 'Invalid password'),
                ),
                const Divider(),
                TextFormField(
                    obscureText: !_repeatedPasswordVisible,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Repeat password',
                      hintText: 'Repeat your password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _repeatedPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            _repeatedPasswordVisible =
                                !_repeatedPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (val) {
                      if (val != _passwordController.text) {
                        return 'Passwords Not Match';
                      }
                      return null;
                    }),
                const Divider(),
                TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                      hintText: 'Enter your name'),
                  controller: _nameController,
                  validator: RequiredValidator(errorText: 'Invalid name'),
                ),
                const Divider(),
                Row(children: [
                  const Text(
                    'Sex',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  DropdownButton<Sex>(
                    value: _sex,
                    icon: const Icon(Icons.arrow_downward),
                    onChanged: (Sex newValue) {
                      setState(() {
                        _sex = newValue;
                      });
                    },
                    items: Sex.values.map<DropdownMenuItem<Sex>>((Sex value) {
                      return DropdownMenuItem<Sex>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                  ),
                ]),
                const Divider(),

                // date picker

                Center(
                  child: Text(
                    _birthDate == null
                        ? 'Pick date'
                        : '${_birthDate.day}/${_birthDate.month}/${_birthDate.year}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
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
      ),
    );
  }
}
