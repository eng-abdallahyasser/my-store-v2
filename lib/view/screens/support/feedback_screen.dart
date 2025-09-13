import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/core/constants.dart';
import 'package:store_app_v2/data/data_source/repo.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  String _type = 'Suggestion';

  static const String developerGithubUrl = 'https://github.com/eng-abdallahyasser';

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = Repo.auth.getCurrentUser();
    if (user == null) {
      Get.snackbar('Login required', 'Please login to send your feedback');
      return;
    }

    try {
      FocusScope.of(context).unfocus();
      await Repo.submitFeedback(
        type: _type,
        message: _messageController.text.trim(),
        userId: user.uid,
      );
      Get.snackbar('Thank you', 'Your ${_type.toLowerCase()} has been sent');
      Navigator.of(context).pop();
    } catch (e) {
      Get.snackbar('Error', 'Failed to send. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggestions & Complaints'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Suggestion', child: Text('Suggestion')),
                  DropdownMenuItem(value: 'Complaint', child: Text('Complaint')),
                ],
                onChanged: (v) => setState(() => _type = v ?? 'Suggestion'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _messageController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Describe your suggestion or complaint',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Please enter your message';
                  }
                  if (v.trim().length < 10) {
                    return 'Please provide more details (at least 10 characters)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.mainColor,
                  ),
                  onPressed: _submit,
                  child: const Text('Send'),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      final uri = Uri.parse(developerGithubUrl);
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    },
                    icon: const Icon(Icons.person_outline, size: 16),
                    label: const Text(
                      'About developer',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
