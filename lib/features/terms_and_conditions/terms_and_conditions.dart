import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 16.0),
            Text(
              'Please read these terms and conditions carefully before using Our Service.\n\n'
              'Section 1: Introduction\n'
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\n'
              'Section 2: Intellectual Property\n'
              'The Service and its original content, features and functionality are and will remain the exclusive property of the Company and its licensors.\n\n'
              'Section 3: Changes to Service\n'
              'We reserve the right to withdraw or amend our Service, and any service or material we provide via the Service, in our sole discretion without notice. We will not be liable if for any reason all or any part of the Service is unavailable at any time or for any period.\n\n'
              'Section 4: Amendments to Terms\n'
              'We may update the terms of this agreement from time to time. It is your responsibility to check this page periodically for changes.\n\n'
              'Section 5: Acknowledgement\n'
              'BY USING SERVICE OR OTHER SERVICES PROVIDED BY US, YOU ACKNOWLEDGE THAT YOU HAVE READ THESE TERMS OF SERVICE AND AGREE TO BE BOUND BY THEM.\n\n'
              'Please replace this text with your actual terms and conditions.',
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
