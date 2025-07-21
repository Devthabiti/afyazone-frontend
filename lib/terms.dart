//

import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: Color(0xff262626),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xff262626),
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Last Updated: September 15, 2024',
                  style: textTheme.bodySmall
                      ?.copyWith(fontSize: 13, color: Colors.grey[700])),
              const SizedBox(height: 20),
              _buildSection(
                context,
                title: 'Introduction',
                content:
                    'This Privacy Policy describes how we collect, use, and share your personal information when you use our service. By using this app, you agree to the terms outlined here.',
              ),
              _buildSection(
                context,
                title: 'What Personal Information We Collect',
                content:
                    'We automatically collect certain information such as your time zone, phone number, username, and cookies installed on your device. We also collect data on pages you visit and how you interact with the app.',
              ),
              _buildSection(
                context,
                title: 'Usage Data',
                content:
                    'We collect usage data such as:\n\n• IP address\n• Browser type and version\n• App pages visited\n• Time and date of visits\n• Time spent per page\n\nWhen using a mobile device, we may also collect:\n• Mobile device type and ID\n• OS version and mobile browser\n• Diagnostic data\n• Location and camera access (with permission)',
              ),
              _buildSection(
                context,
                title: 'Your Rights',
                content:
                    'You have the right to access, update, or delete your personal data. To exercise these rights, please contact us.',
              ),
              _buildSection(
                context,
                title: 'Data Security',
                content:
                    'We implement strict measures to protect your personal data and limit access to authorized personnel only. In case of a data breach, we will notify affected parties as required by law.',
              ),
              _buildSection(
                context,
                title: 'Changes to this Policy',
                content:
                    'We may update this policy periodically. Any changes will be posted here along with an updated "Last Updated" date.',
              ),
              _buildSection(
                context,
                title: 'Contact Us',
                content:
                    'If you have any questions, feel free to contact us:\n\n📧 Email: sideukas@gmgail.com\n📞 Phone: +255 777 048 047',
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required String content}) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: textTheme.bodyMedium?.copyWith(height: 1.5, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
