import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'home.dart';
import 'help.dart';
import 'settings.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  int _currentIndex = 1;

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    final pages = [const HomePage(), const AnalyticsPage(), const HelpPage(), const SettingsPage()];
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => pages[index]));
  }

  final List<double> temperatureData = [24.5, 25.0, 24.8, 25.2, 24.9];
  final List<double> humidityData = [60, 62, 58, 59, 61];
  final List<double> soilMoistureData = [40, 42, 38, 37, 39];
  final List<double> lightData = [300, 310, 305, 320, 315];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics (Graph View)"),
        backgroundColor: Colors.green[700],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildGraphCard("Temperature (°C)", temperatureData, Colors.red),
          _buildGraphCard("Humidity (%)", humidityData, Colors.blue),
          _buildGraphCard("Soil Moisture (%)", soilMoistureData, Colors.brown),
          _buildGraphCard("Light Level (lux)", lightData, Colors.orange),
        ],
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

  Widget _buildGraphCard(String title, List<double> values, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, _) =>
                            Text(value.toInt().toString()),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, interval: 5),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        values.length,
                            (index) => FlSpot(index.toDouble(), values[index]),
                      ),
                      isCurved: true,
                      color: color,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
