import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../logger.dart';
import '../services/profile_service.dart';
import '../utils.dart';
import 'dtos/get_profile.dto.dart';
import 'dtos/update_profile.dto.dart';

class ProfileEditWidget extends StatefulWidget {
  final GetProfileDto profile;

  @override
  _ProfileEditState createState() => _ProfileEditState();

  const ProfileEditWidget({this.profile}) : super();
}

class _ProfileEditState extends State<ProfileEditWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  DateTime _birthDate;

  static const sizedBoxHeight = 30.0;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final profile = widget.profile;
    refreshProfile(profile);
  }

  void refreshProfile(GetProfileDto profile) {
    _emailController.text = profile.email;
    _nameController.text = profile.name;
    _birthDate = profile.birthDate;
  }

  @override
  void didUpdateWidget(ProfileEditWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.profile != oldWidget.profile) {
      refreshProfile(widget.profile);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime timePicked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      //todo: fix
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

  @override
  Widget build(BuildContext context) {
    const divider = SizedBox(
      height: sizedBoxHeight,
    );


    return Form(
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
              ),
              controller: _emailController,
              enabled: false,
            ),
            divider,
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  hintText: 'Enter your name'),
              controller: _nameController,
              validator: RequiredValidator(errorText: 'Invalid name'),
            ),
            divider,

            // date picker

            Center(
              child: Text(
                _birthDate == null
                    ? 'Pick date'
                    : 'Birth date: ${_birthDate.day}/${_birthDate.month}/${_birthDate.year}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            divider,
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
    );
  }
}
