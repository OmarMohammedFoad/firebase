import 'package:flutter/material.dart';

class TermsAndConditionsDialog extends StatefulWidget {
  @override
  _TermsAndConditionsDialogState createState() => _TermsAndConditionsDialogState();
}

class _TermsAndConditionsDialogState extends State<TermsAndConditionsDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Terms and Conditions"),
      content: const SingleChildScrollView(
        child: Text("Your terms and conditions text goes here."),
      ),
      actions: [
        TextButton(
          child: const Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}