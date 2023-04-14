import 'package:flutter/material.dart';

class TermsAndConditionsDialog extends StatefulWidget {
  @override
  _TermsAndConditionsDialogState createState() => _TermsAndConditionsDialogState();
}

class _TermsAndConditionsDialogState extends State<TermsAndConditionsDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Terms and Conditions"),
      content: SingleChildScrollView(
        child: Text("Welcome to our mobile app. "
            "If you continue to browse and use this mobile app, you are agreeing to comply with and be bound by the following terms and conditions of use, which together with our privacy policy govern our relationship with you in relation to this mobile app. "
            "If you disagree with any part of these terms and conditions, please do not use our mobile app.\n\n"
            "1. The content of the pages of this mobile app is for your general information and use only.\n\n"
            "2. Your use of any information or materials on this website/mobile app is entirely at your own risk, for which we shall not be liable. It shall be your own responsibility to ensure that any products, services or information available through this mobile app meet your specific requirements.\n\n"
            "3. This mobile app contains material which is owned by us or licensed to us. This material includes, but is not limited to, the design, layout, look, appearance, and graphics.\n\n"
            "4. We reserve the right to modify or terminate the mobile app or to modify these terms and conditions at any time, without prior notice.\n\n"
            "5. By using this website/mobile app, you agree to our privacy policy.\n\n"
            "6. We do not guarantee the accuracy, completeness, timeliness, or reliability of any content on this mobile app.\n\n"
            "7. You agree to indemnify and hold us harmless from any claim or demand, including reasonable attorneys' fees, made by any third party due to or arising out of your breach of these terms and conditions or your violation of any law or the rights of a third party.\n\n"
            "Thank you for using our mobile app."),
      ),
      actions: [
        TextButton(
          child: Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}