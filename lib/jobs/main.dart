import 'dart:async';
import 'package:workmanager/workmanager.dart';

import 'send-geodata/job/send-geodata.job.dart';
import '../constants.dart';

void jobDispatcher() {
  Workmanager.executeTask((task, inputData) {
    if (task == SEND_GEODATA_JOB) sendGeoData();
    return Future.value(true);
  });
}

void initJobs() {
  Workmanager.initialize(jobDispatcher);
  Workmanager.registerPeriodicTask(SEND_GEODATA_JOB, SEND_GEODATA_JOB,
      tag: SEND_GEODATA_TAG);
}
