import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fypcikman/settings.dart';
import 'package:fypcikman/analytic.dart';
import 'package:fypcikman/help.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isPumpOn = false;
  bool _isAutoMode = false;

  final DatabaseReference _pumpRef = FirebaseDatabase.instance.ref("sensor_data/pump_status");
  final DatabaseReference _sensorRef = FirebaseDatabase.instance.ref("sensor_data");

  int _currentIndex = 0;

  Map<String, dynamic> _sensorData = {
    'temperature': 'Loading...',
    'humidity': 'Loading...',
    'soilMoisture': 'Loading...',
    'light': 'Loading...'
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();
    _listenToPumpStatus();
    _listenToSensorData();
  }

  void _listenToPumpStatus() {
    _pumpRef.onValue.listen((event) {
      final value = event.snapshot.value;
      if (value != null && value is bool) {
        setState(() {
          _isPumpOn = value;
        });
      }
    });
  }

  void _listenToSensorData() {
    _sensorRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        setState(() {
          _sensorData = Map<String, dynamic>.from(data);
        });

        // Auto mode controls pump based on soil moisture
        if (_isAutoMode) {
          _autoControlPump();
        }
      }
    });
  }

  void _autoControlPump() {
    // Example threshold: soil moisture < 30, turn ON pump
    final soilMoistureStr = _sensorData['soilMoisture'].toString();
    final soilMoisture = double.tryParse(soilMoistureStr) ?? 0;

    final shouldPumpOn = soilMoisture < 30;

    if (_isAutoMode) {
      _pumpRef.set(shouldPumpOn);
      setState(() {
        _isPumpOn = shouldPumpOn;
      });
    }
  }

  void _togglePump(bool value) async {
    if (_isAutoMode) return; // Prevent manual control in Auto Mode

    try {
      await _pumpRef.set(value);
      setState(() {
        _isPumpOn = value;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Water Pump ${value ? 'ON' : 'OFF'}'),
          backgroundColor: value ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengawal pam'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const AnalyticsPage()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpPage()));
    } else if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF0),
      appBar: AppBar(
        title: const Text('Smart IoT Farming'),
        centerTitle: true,
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            ),
          );
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/farm_bg.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.white70, BlendMode.lighten),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Image.network(
                            'https://smartfarm.nl/wp-content/uploads/2024/02/yoast-organisation-logo.jpg',
                            height: 100,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Welcome to Smart Farm',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF388E3C),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Real-time monitoring and control of your farming operations',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Farm Status Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _buildStatusCard('Temperature', '${_sensorData['temperature']}°C', Icons.thermostat, Colors.orange),
                      _buildStatusCard('Humidity', '${_sensorData['humidity']}%', Icons.water_drop, Colors.blue),
                      _buildStatusCard('Soil Moisture', '${_sensorData['soil_moisture']}', Icons.grass, Colors.brown),
                      _buildStatusCard('Light Level', '${_sensorData['ldr']}', Icons.light_mode, Colors.yellow),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Mode: ',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Text('Manual'),
                      Switch(
                        value: _isAutoMode,
                        onChanged: (value) {
                          setState(() {
                            _isAutoMode = value;
                          });

                          if (_isAutoMode) {
                            _autoControlPump();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Auto Mode Aktif'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Manual Mode Aktif'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        },
                      ),
                      const Text('Auto'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Water Pump Control',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    Icons.opacity,
                                    size: 40,
                                    color: _isPumpOn ? Colors.blue : Colors.grey,
                                  ),
                                  const SizedBox(height: 10),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: _isPumpOn ? Colors.green : Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                              Switch.adaptive(
                                value: _isPumpOn,
                                onChanged: _togglePump,
                                activeColor: Colors.blue,
                                activeTrackColor: Colors.blue.withOpacity(0.4),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _isPumpOn ? 'Pam AIR AKTIF' : 'Pam AIR TIDAK AKTIF',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _isPumpOn ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Graf'),
          BottomNavigationBarItem(icon: Icon(Icons.help_outline), label: 'Help'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded), label: 'Profile'),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green[700],
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildStatusCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
