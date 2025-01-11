import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Last updated: September 15, 2024',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 16.0),
            Text(
                'This Privacy Policy describes our policies and procedures on the collection, use, and disclosure of your information when you use our service and informs you about your privacy rights and how the law protects you.\n\nBy using the service, you agree to the collection and use of information in accordance with this Privacy Policy.',
                style: TextStyle(fontSize: 14)),
            SizedBox(height: 16.0),
            Text('WHAT PERSONAL INFORMATION WE COLLECT'.toLowerCase(),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.0),
            Text(
                'When you use this Application, we automatically collect certain information about your device, including information about your time zone, phone number, username  and some of the cookies that are installed on your device.\n\nAdditionally, as you use this Applications, we collect information about the individual App pages or products that you view, or search terms referred you to the Application, and information about how you interact with the App. We refer to this automatically collected information as Device Information.',
                style: TextStyle(fontSize: 14)),
            SizedBox(height: 16.0),
            Text('Usage Data',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.0),
            Text(
              'Usage Data is collected automatically when using the Service. It may include information such as:\n- Your Device\'s Internet Protocol address (e.g., IP address)\n- Browser type and version\n- Pages of our Service that you visit\n- Time and date of your visit\n- Time spent on those pages\n- Unique device identifiers and other diagnostic data\n\nWhen accessing the Service via a mobile device, we may collect:\n- Type of mobile device you use\n- Mobile device unique ID\n- IP address of your mobile device\n- Mobile operating system\n- Type of mobile Internet browser you use\n- Unique device identifiers and other diagnostic data\n\nInformation Collected while Using the Application\nWith your prior permission, we may collect:\n- Information regarding your background location if \'background location\' is turned on\n- Pictures and other information from your device\'s camera and photo library.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              'Your information may be transferred to and maintained on computers located outside of your jurisdiction. By using our Service, you consent to the transfer of your data. The Company will take steps to ensure your data is treated securely and in accordance with this Privacy Policy.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 16.0),
            Text('YOUR RIGHTS'.toLowerCase(),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.0),
            Text(
              'you have the right to access the personal information we hold about you and to ask that your personal information is corrected, updated, or deleted. If you would like to exercise this right, please contact us.',
            ),
            SizedBox(height: 16.0),
            Text('DATA SECURITY'.toLowerCase(),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.0),
            Text(
                'We have put in place appropriate security measures to prevent your personal data from being accidentally lost, used or accessed in an unauthorised way, altered or disclosed.In addition, we limit access to your personal data to those employees, agents, contractors and other third parties who have a business need to know. They will only process your personal data on our instructions and they are subject to a duty of confidentiality.We have put in place procedures to deal with any suspected personal data breach and will notify you and any applicable regulator of a breach where we are legally required to do so.'),
            SizedBox(height: 16.0),
            Text('Changes to this Privacy Policy',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.0),
            Text(
              'We may update our Privacy Policy from time to time. We will notify you of changes by posting the new Privacy Policy on this page and updating the "Last Updated" date. You are advised to review this Privacy Policy periodically.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 16.0),
            Text('Contact Us',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.0),
            Text(
              'If you have any questions about this Privacy Policy, you can contact us at:\n- Email: sideukas@gmgail.com\n- Phone: +255 777 048 047',
            ),
          ],
        ),
      ),
    );
  }
}
