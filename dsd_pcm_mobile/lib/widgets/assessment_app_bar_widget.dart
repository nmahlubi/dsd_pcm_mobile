import 'package:flutter/material.dart';

Widget assessmentAppBarWidget(String? titleValue) {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  return AppBar(
    title: Text(titleValue!),
    leading: IconButton(
      icon: const Icon(Icons.offline_pin_rounded),
      onPressed: () {
        if (scaffoldKey.currentState!.isDrawerOpen) {
          scaffoldKey.currentState!.closeDrawer();
          //close drawer, if drawer is open
        } else {
          scaffoldKey.currentState!.openDrawer();
          //open drawer, if drawer is closed
        }
      },
    ),
  );
}
