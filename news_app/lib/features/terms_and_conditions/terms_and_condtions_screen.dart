import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to NewsApp!',
                      style: theme.titleMedium, // fontSize: 20
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'By using this application, you agree to the following terms and conditions. Please read them carefully.',
                      style: theme.bodyMedium, // fontSize: 14
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '1. Usage of Service',
                      style: theme.titleSmall, // fontSize: 16, bold
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You agree to use the application only for lawful purposes and in a way that does not infringe on the rights of others.',
                      style: theme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '2. Data and Privacy',
                      style: theme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We collect minimal personal information. Your data is stored securely and never shared with third parties without your consent.',
                      style: theme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '3. Changes to Terms',
                      style: theme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We reserve the right to update these terms at any time. We will notify you of any significant changes.',
                      style: theme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '4. Disclaimer',
                      style: theme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'All content provided is for informational purposes only. We do not guarantee the accuracy or completeness of news data.',
                      style: theme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'By continuing to use the app, you accept and agree to these terms.',
                      style: theme.bodyMedium,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Accept'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
