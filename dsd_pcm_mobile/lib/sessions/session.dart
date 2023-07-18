import 'dart:async';

import 'package:flutter/material.dart';

class Session {
  BuildContext? context;
  StreamController? streamController;
  bool enableLoginPage = true;

  //by using this function we will able to start the session
  void startListener(
      {required StreamController streamController,
      required BuildContext context}) {
    this.streamController = streamController;
    this.context = context;
    Map<String, dynamic> map = {'context': context, 'timer': true};
    streamController.add(map);
  }

  //by using this function we will able to stop the session
  void stopListener(
      {required StreamController streamController,
      required BuildContext context}) {
    this.streamController = streamController;
    this.context = context;
    enableLoginPage = false;
    Map<String, dynamic> map = {'context': context, 'timer': false};
    streamController.add(map);
  }
}
