import 'dart:async';

import 'package:workmanager/workmanager.dart';

import '../constants.dart';
import 'send-geodata.job.dart';

void jobDispatcher() {
  Workmanager.executeTask((task, inputData) {
    if (task == sendGeodataJob) sendGeoData();
    return Future.value(true);
  });
}

void initJobs() {
  Workmanager.initialize(jobDispatcher);
  Workmanager.registerPeriodicTask(sendGeodataJob, sendGeodataJob,
      tag: sendGeodataTag);
}
