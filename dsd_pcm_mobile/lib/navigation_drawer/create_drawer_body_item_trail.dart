import 'package:flutter/material.dart';

Widget createDrawerBodyItemTrail(
    {IconData? icon, String? text, GestureTapCallback? onTap, bool? status}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(text!),
        ),
      ],
    ),
    trailing: status == true
        ? const Icon(Icons.check, color: Colors.green)
        : const Icon(Icons.close, color: Colors.red),
    onTap: onTap,
  );
}
