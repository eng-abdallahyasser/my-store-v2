import 'package:flutter/material.dart';
import 'package:store_app_v2/data/data_source/repo.dart';
import 'package:store_app_v2/data/model/terms.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  String _formatTimestamp(Terms terms) {
    if (terms.updatedAt == null) return '';
    final dt = terms.updatedAt!.toDate();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} ${two(dt.hour)}:${two(dt.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الشروط والأحكام'),
      ),
      body: StreamBuilder<Terms?>(
        stream: Repo.terms.latestTermsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'لا توجد شروط وأحكام حالياً. يرجى المحاولة لاحقاً.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final terms = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  terms.title.isNotEmpty ? terms.title : 'الشروط والأحكام',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (terms.updatedAt != null)
                      Text(
                        _formatTimestamp(terms),
                        style: const TextStyle(color: Colors.grey),
                      ),
                  ],
                ),
                const Divider(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: SelectableText(
                      terms.content,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
