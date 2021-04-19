import 'dart:convert';

import 'package:dct_client/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../constants.dart';
import '../drawer_child_widget.dart';
import '../logger.dart';
import '../services/profile_service.dart';
import '../utils.dart';
import 'dtos/get_profile.dto.dart';
import 'dtos/update_profile.dto.dart';

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  DateTime _birthDate;

  static const sizedBoxHeight = 30.0;

  var _isLoading = true;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    getProfile();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime timePicked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (timePicked != null && timePicked != _birthDate) {
      setState(() {
        _birthDate = timePicked;
      });
    }
  }

  Future<void> _update(BuildContext context) async {
    try {
      if (!_formKey.currentState.validate()) {
        return;
      }

      final dto =
          UpdateProfileDto(_nameController.text, _birthDate.toIso8601String());

      final response = await ProfileService.updateProfile(dto);

      if (!Utils.isStatusCodeOk(response.statusCode)) {
        //todo: make snackbar good
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to update profile',
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
        return;
      }
    } catch (e) {
      logger.e(e);

      //todo: make snackbar good
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

  Future<void> getProfile() async {
    final resp = await ProfileService.getProfile();
    setState(() {
      _isLoading = false;
    });
    if (!Utils.isStatusCodeOk(resp.statusCode)) {
      if (Utils.isUnauthorized(resp.statusCode)) {
        AuthService.logout();
      }
      Utils.logHttpError(resp);
      // return const Text('Error', style: TextStyle(color: Colors.red));
    }

    final profile = GetProfileDto.fromJson(jsonDecode(resp.body));
    _emailController.text = profile.email;
    _nameController.text = profile.name;
    setState(() {
      _birthDate = profile.birthDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(child: DrawerChildWidget(profileHeader)),
      appBar: AppBar(
        title: const Text(appTitle),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: sizedBoxHeight,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            hintText: 'Enter your email'),
                        controller: _emailController,
                        validator: EmailValidator(errorText: 'Invalid email'),
                      ),
                      const SizedBox(
                        height: sizedBoxHeight,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Name',
                            hintText: 'Enter your name'),
                        controller: _nameController,
                        validator: RequiredValidator(errorText: 'Invalid name'),
                      ),
                      const SizedBox(
                        height: sizedBoxHeight,
                      ),

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
                            backgroundColor: MaterialStateProperty.all(
                                Colors.lightBlueAccent)),
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
                        onPressed: () => _update(context),
                        child: const Text(
                          'Update',
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
