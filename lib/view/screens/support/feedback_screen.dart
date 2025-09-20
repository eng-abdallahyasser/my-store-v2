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

  static const String developerGithubUrl = 'https://www.linkedin.com/in/abdallah-yasser-30a1681a1/';

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = Repo.auth.getCurrentUser();
    if (user == null) {
      Get.snackbar('تسجيل الدخول مطلوب', 'يرجى تسجيل الدخول لإرسال ملاحظاتك');
      return;
    }

    try {
      FocusScope.of(context).unfocus();
      await Repo.submitFeedback(
        type: _type,
        message: _messageController.text.trim(),
        userId: user.uid,
      );
      Get.snackbar('شكراً لك', 'تم إرسال رسالتك بنجاح');
      Navigator.of(context).pop();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل الإرسال. يرجى المحاولة مرة أخرى.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الاقتراحات والشكاوى'),
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
                  DropdownMenuItem(value: 'Bug', child: Text('Bug')),
                  DropdownMenuItem(value: 'Others', child: Text('Others')),
                ],
                onChanged: (v) => setState(() => _type = v ?? 'Suggestion'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _messageController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Describe your feedback',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'يرجى إدخال رسالتك';
                  }
                  if (v.trim().length < 10) {
                    return 'يرجى تقديم مزيد من التفاصيل (على الأقل 10 أحرف)';
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
                  child: const Text('Send',style: TextStyle(color: Colors.white),),
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
                      style: TextStyle(fontSize: 12 ,color: Colors.black),
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
