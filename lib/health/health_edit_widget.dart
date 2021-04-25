import 'package:flutter/material.dart';

import '../logger.dart';
import '../services/health_service.dart';
import '../utils.dart';
import 'dtos/get_health.dto.dart';
import 'dtos/update_health.dto.dart';
import 'enums/health_status_enum.dart';

class HealthEditWidget extends StatefulWidget {
  final GetHealthDto health;

  @override
  _HealthEditState createState() => _HealthEditState();

  const HealthEditWidget({this.health}) : super();
}

class _HealthEditState extends State<HealthEditWidget> {
  final _formKey = GlobalKey<FormState>();
  HealthStatus _status;

  static const sizedBoxHeight = 30.0;

  @override
  void initState() {
    super.initState();

    final health = widget.health;
    refreshHealth(health);
  }

  void refreshHealth(GetHealthDto health) {
    _status = health.status;
  }

  @override
  void didUpdateWidget(HealthEditWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.health != oldWidget.health) {
      refreshHealth(widget.health);
    }
  }

  Future<void> _update(BuildContext context) async {
    try {
      if (!_formKey.currentState.validate()) {
        return;
      }

      final dto = UpdateHealthDto(_status);

      final response = await HealthService.updateHealth(dto);

      if (!Utils.isStatusCodeOk(response.statusCode)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to update health',
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
        return;
      }
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
    const hDivider = SizedBox(
      height: sizedBoxHeight,
    );

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: ListView(
          children: [
            hDivider,
            Row(
              children: [
                const Text(
                  'Status',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  width: 20,
                ),
                DropdownButton<HealthStatus>(
                  value: _status,
                  icon: const Icon(Icons.arrow_downward),
                  onChanged: (HealthStatus newValue) {
                    setState(() {
                      _status = newValue;
                    });
                  },
                  items: HealthStatus.values
                      .map<DropdownMenuItem<HealthStatus>>(
                          (HealthStatus value) {
                    return DropdownMenuItem<HealthStatus>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                )
              ],
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
