import 'dart:async';
import 'package:flutter/material.dart';

class SessionManager extends StatefulWidget {
  Widget child;
  Duration duration;
  VoidCallback onSessionTimeExpired;
  StreamController streamController;

  SessionManager({
    Key? key,
    required this.child,
    required this.onSessionTimeExpired,
    required this.duration,
    required this.streamController,
  }) : super(key: key);

  @override
  State<SessionManager> createState() => _SessionManagerState();
}

class _SessionManagerState extends State<SessionManager> {
  Timer? _sessionTimer;
  late StreamController streamController;

  //by using this function start the session timer
  void _startSessionTimer() {
    _sessionTimer = Timer(widget.duration, () {
      widget.onSessionTimeExpired();
      cancelTimer();
    });
  }

  // by using this close the session timer
  void cancelTimer() {
    if (_sessionTimer != null) {
      _sessionTimer!.cancel();
    }
  }

  //by using this able to start session
  void _startSession() {
    cancelTimer();
    _startSessionTimer();
  }

  @override
  void initState() {
    super.initState();
    streamController = StreamController();
    streamController = widget.streamController;
    if (streamController != null) {
      streamController.stream.listen((event) {
        if (event != null && event['timer'] as bool) {
          _startSession();
        } else {
          cancelTimer();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => {_startSession()},
      child: widget.child,
    );
  }
}
