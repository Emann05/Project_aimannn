import 'package:flutter/material.dart';
import 'package:fypcikman/settings.dart';
import 'package:fypcikman/analytic.dart';
import 'package:fypcikman/home.dart';
import 'package:fypcikman/help.dart';
import 'package:fypcikman/first.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _currentIndex = 3;

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
    final pages = [HomePage(), AnalyticsPage(), HelpPage(), SettingsPage()];
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => pages[index]),
    );
  }

  void _logOut() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LandingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E4053),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logOut,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 20),
            _buildAboutSection(),
            const SizedBox(height: 20),
            _buildSkillsSection(),
            const SizedBox(height: 20),
            _buildExperienceSection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 3,
              )
            ],
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundImage: const AssetImage('assets/img.png'),
            backgroundColor: Colors.blueGrey[100],
          ),
        ),
        const SizedBox(height: 15),
        Text(
          'Muhammad Aiman Farhan Bin Su',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[900],
            letterSpacing: 1.1,
          ),
        ),
        Text(
          'Mobile Developer & UI Designer',
          style: TextStyle(
            fontSize: 16,
            color: Colors.blueGrey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blueGrey[800]),
                const SizedBox(width: 10),
                Text(
                  'About Me',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              'Passionate developer with 1+ years experience in mobile app development. '
                  'Specializing in Flutter framework and Firebase backend integration. '
                  'Love creating beautiful and functional user interfaces.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey[800],
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 15),
            _buildInfoRow(Icons.email, 'aimanfarhan@gmail.com'),
            _buildInfoRow(Icons.location_on, 'Petaling Jaya, Selangor'),
            _buildInfoRow(Icons.work_outline, 'KKTM Petaling Jaya'),
            _buildInfoRow(Icons.school, 'Engineering Electronic (IoT)'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey[600]),
          const SizedBox(width: 15),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.blueGrey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.code, color: Colors.blueGrey[800]),
                const SizedBox(width: 10),
                Text(
                  'Technical Skills',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildSkillChip('Flutter', Icons.phone_android),
                _buildSkillChip('Firebase', Icons.cloud),
                _buildSkillChip('UI/UX Design', Icons.design_services),
                _buildSkillChip('Dart', Icons.developer_mode),
                _buildSkillChip('REST API', Icons.api),
                _buildSkillChip('Git', Icons.developer_board),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.work_history, color: Colors.blueGrey[800]),
                const SizedBox(width: 10),
                Text(
                  'Experience',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildExperienceItem(
              'Senior Mobile Developer',
              'Tech Solutions Inc. (2025-Present)',
              'Led Flutter team in developing enterprise mobile applications',
            ),
            _buildExperienceItem(
              'Junior Developer',
              'Digital Innovations Co. (2024-2025)',
              'Developed and maintained mobile apps for various clients',
            ),
            _buildExperienceItem(
              'Student Developer',
              'Startup Hub (2023-2024)',
              'Assisted in mobile app development and testing',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceItem(String title, String subtitle, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey[900],
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.blueGrey[600],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              color: Colors.blueGrey[800],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.white),
      label: Text(skill),
      backgroundColor: Colors.blueGrey[700],
      labelStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  BottomNavigationBar _buildNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Graf'),
        BottomNavigationBarItem(icon: Icon(Icons.help_outline), label: 'Help'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      currentIndex: _currentIndex,
      selectedItemColor: Colors.green[700],
      unselectedItemColor: Colors.grey[600],
      onTap: _onTabTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 8,
    );
  }
}