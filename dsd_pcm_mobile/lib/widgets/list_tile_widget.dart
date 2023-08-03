import 'package:flutter/material.dart';

Widget listTileWidget({IconData? icon, String? text, bool? status}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 0.2, bottom: 0.2),
          child: Text(text!),
        ),
      ],
    ),
    trailing: status == true
        ? const Icon(Icons.check, color: Colors.green)
        : const Icon(Icons.close, color: Colors.red),
  );
}
