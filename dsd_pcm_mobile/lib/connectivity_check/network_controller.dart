import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkStatus extends StatelessWidget {
  final ConnectivityResult connectivityResult;

  NetworkStatus(this.connectivityResult);

  Widget _buildConnectionIndicator() {
    IconData icon;
    Color color;

    switch (connectivityResult) {
      case ConnectivityResult.wifi:
        icon = Icons.wifi;
        color = Colors.green;
        break;
      case ConnectivityResult.mobile:
        icon = Icons.error;
        color = Colors.green;
        break;
      default:
        icon = Icons.signal_wifi_off;
        color = Colors.red;
        break;
    }

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Icon(
        icon,
        color: color,
        size: 30.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildConnectionIndicator();
  }
}
