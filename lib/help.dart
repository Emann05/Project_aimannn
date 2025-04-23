import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fypcikman/home.dart';
import 'package:fypcikman/analytic.dart';
import 'package:fypcikman/help.dart';
import 'package:fypcikman/settings.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final List<FAQItem> faqs = [
    FAQItem(
      question: 'How do I create a new account?',
      answer: 'Go to the Settings page and click on "Create New Account"',
    ),
    FAQItem(
      question: 'How to reset my password?',
      answer: 'Use the forgot password link on the login screen',
    ),
    FAQItem(
      question: 'How to export data?',
      answer: 'In Analytics page, use the export button in top-right corner',
    ),
  ];

  final List<TutorialItem> tutorials = [
    TutorialItem(title: 'Getting Started', duration: '5:30', url: 'https://youtu.be/1xipg02Wu8s?feature=shared'),
    TutorialItem(title: 'Advanced Features', duration: '8:15', url: 'https://www.youtube.com/watch?v=video2'),
    TutorialItem(title: 'Data Analytics', duration: '6:45', url: 'https://www.youtube.com/watch?v=video3'),
  ];

  int _currentIndex = 2;

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
    final pages = [HomePage(), AnalyticsPage(), HelpPage(), SettingsPage()];
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => pages[index]),
    );
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'aimanfarhan1234567890@gmail.com',
      query: 'subject=App Support Request',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open email app")),
      );
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '0162110753');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch dialer")),
      );
    }
  }

  Future<void> _launchTutorial(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open video link")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Frequently Asked Questions'),
            _buildFAQs(),
            const SizedBox(height: 20),
            _buildSectionTitle('Contact Support'),
            _buildContactCard(),
            const SizedBox(height: 20),
            _buildSectionTitle('Video Tutorials'),
            _buildVideoTutorials(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Graf'),
          BottomNavigationBarItem(icon: Icon(Icons.help_outline), label: 'Help'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey[600],
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.green[700],
        ),
      ),
    );
  }

  Widget _buildFAQs() {
    return Column(
      children: faqs
          .map((faq) => ExpansionTile(
        title: Text(faq.question),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(faq.answer),
          )
        ],
      ))
          .toList(),
    );
  }

  Widget _buildContactCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.email, color: Colors.green[700]),
              title: const Text('Email Support'),
              subtitle: const Text('aimanfarhan1234567890@gmail.com'),
              onTap: _launchEmail,
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.green[700]),
              title: const Text('Call Support'),
              subtitle: const Text('016-211-0753'),
              onTap: _launchPhone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoTutorials() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tutorials.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _launchTutorial(tutorials[index].url),
            child: Container(
              width: 200,
              margin: const EdgeInsets.only(right: 10),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_circle_fill, size: 50, color: Colors.green[700]),
                    const SizedBox(height: 10),
                    Text(tutorials[index].title),
                    Text(
                      tutorials[index].duration,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}

class TutorialItem {
  final String title;
  final String duration;
  final String url;

  TutorialItem({required this.title, required this.duration, required this.url});
}
