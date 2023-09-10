import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkStatusChecker {
  final BuildContext context;

  NetworkStatusChecker(this.context);

  Future<void> checkNetworkStatus() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // Display a Snackbar indicating that the user is working offline.
      showSnackbar("You are working offline");
    } else {
      // Display a Snackbar indicating that the user is connected to the network.
      showSnackbar("You are connected to the network");
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 10),
      ),
    );
  }
}
