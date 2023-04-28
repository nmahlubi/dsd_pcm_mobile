import 'package:flutter/material.dart';

alertDialogMessageWidget(
    BuildContext context, String? headerMessage, String? message) async {
  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(headerMessage!),
      content: Text(message!),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          child: Container(
            //color: Colors.green,
            padding: const EdgeInsets.all(14),
            child: const Text("okay"),
          ),
        ),
      ],
    ),
  );
}
