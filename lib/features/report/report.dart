// ignore_for_file: use_build_context_synchronously

import 'package:bu_connect/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

final reportFormProvider =
    StateProvider.autoDispose((ref) => ReportFormState());

class ReportFormState {
  String communityName = '';
  String reportContent = '';
}

class ReportPage extends ConsumerWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider)!;
    final reportFormState = ref.watch(reportFormProvider);

    void submitReport() async {
      try {
        final Email email = Email(
          body:
              'Community/User Name: ${reportFormState.communityName}\nReport: ${reportFormState.reportContent} from ${user.name}',
          subject: 'Community/User Report',
          recipients: ['sodeeqalli@gmail.com'],
          isHTML: false,
        );
        await FlutterEmailSender.send(email);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Report submitted successfully!'),
              backgroundColor: Colors.green),
        );
      } catch (e) {
        // Consider using a logger or showing this in the UI for debugging
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to submit report.'),
              backgroundColor: Colors.red),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Community/User Name'),
              onChanged: (value) => ref
                  .read(reportFormProvider.notifier)
                  .update((state) => state..communityName = value),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Report Content'),
              onChanged: (value) => ref
                  .read(reportFormProvider.notifier)
                  .update((state) => state..reportContent = value),
              maxLines: 5,
            ),
            ElevatedButton(
              onPressed: submitReport,
              child: const Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }
}
