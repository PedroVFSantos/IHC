import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';

void main() {
  runApp(HealthApp());
}

class HealthApp extends StatelessWidget {
  const HealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Monitor',
      theme: ThemeData(
        primaryColor: const Color(0xFFD90429),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomePage(),
        '/heartRate': (context) => const HeartRatePage(),
        '/stressRate': (context) => const StressRatePage(),
        '/steps': (context) => const StepsPage(),
        '/temperature': (context) => const TemperaturePage(),
        '/bluetooth': (context) => const BluetoothPage(),
      },
    );
  }
}

//Pagina inicial
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Stack(
        children: [
          // Conteúdo principal da tela, por exemplo, o grid de cards.
          Column(
            children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildCard(
                        context, 'Heart Rate', Icons.favorite, '/heartRate'),
                    _buildCard(
                        context, 'Stress Rate', Icons.mood_bad, '/stressRate'),
                    _buildCard(
                        context, 'Steps', Icons.directions_walk, '/steps'),
                    _buildCard(context, 'Temperature', Icons.thermostat,
                        '/temperature'),
                  ],
                ),
              ),
            ],
          ),
          // Ícone de Bluetooth na parte inferior.
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  // Navega para a tela de Bluetooth para parear o dispositivo.
                  Navigator.pushNamed(context, '/bluetooth');
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFD90429),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.bluetooth,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: const Color(0xFFD90429)),
            const SizedBox(height: 16),
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// Tela de Login
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _checkLogin(
      BuildContext context, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final registeredEmail = prefs.getString('email');
    final registeredPassword = prefs.getString('password');

    if (registeredEmail == null || registeredPassword == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not registered. Please sign up!'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (registeredEmail == email && registeredPassword == password) {
      Navigator.pushNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect email or password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite, color: Color(0xFFD90429), size: 64),
              const SizedBox(height: 16),
              const Text('SERENA',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    labelText: 'Email', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Password', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  _checkLogin(
                      context, emailController.text, passwordController.text);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B2D42)),
                child: const Text('Sign In'),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: const Text('Not a member? Sign up!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Cadastro
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleSignup() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Salva as credenciais do usuário no SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _emailController.text);
    await prefs.setString('password', _passwordController.text);

    // Redireciona para a tela de login
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        backgroundColor: const Color(0xFF2B2D42),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            const Icon(
              Icons.person_add,
              size: 100,
              color: Color(0xFFD90429),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _handleSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B2D42),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tela Principal com pareamento Bluetooth
class BluetoothPage extends StatelessWidget {
  const BluetoothPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              BluetoothState state =
                  await FlutterBluetoothSerial.instance.state;
              if (state == BluetoothState.STATE_OFF) {
                ///await FlutterBluetoothSerial.instance.requestEnable();
              }
            },
            child: const Text("Pair Bluetooth Device"),
          ),
          // Aqui você pode adicionar mais elementos da interface de Bluetooth, como lista de dispositivos emparelhados.
        ],
      ),
    );
  }
}

// Tela de Batimentos Cardíacos
class HeartRatePage extends StatefulWidget {
  const HeartRatePage({super.key});

  @override
  _HeartRatePageState createState() => _HeartRatePageState();
}

class _HeartRatePageState extends State<HeartRatePage> {
  String heartRate = '0 bpm';
  List<FlSpot> heartRateData = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _connectToDevice();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _fetchHeartRate();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _connectToDevice() async {
    BluetoothState state = await FlutterBluetoothSerial.instance.state;
    if (state == BluetoothState.STATE_OFF) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bluetooth is off. Please turn it on.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  }

  void _fetchHeartRate() async {
    int simulatedHeartRate = 60 + (30 * (DateTime.now().second % 10));
    setState(() {
      heartRate = '$simulatedHeartRate bpm';
      heartRateData.add(FlSpot(
          heartRateData.length.toDouble(), simulatedHeartRate.toDouble()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Heart Rate Monitor")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite, size: 64, color: Color(0xFFD90429)),
          const SizedBox(height: 16),
          Text(
            heartRate,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: heartRateData,
                    isCurved: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HeartRateStatsPage()),
            ),
            child: const Text('View Statistics'),
          )
        ],
      ),
    );
  }
}

class HeartRateStatsPage extends StatelessWidget {
  const HeartRateStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Heart Rate Statistics")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Daily: 80 bpm avg"),
            Text("Monthly: 75 bpm avg"),
            Text("Yearly: 72 bpm avg"),
          ],
        ),
      ),
    );
  }
}

// Tela de Estresse
class StressRatePage extends StatelessWidget {
  const StressRatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDetailPage(context, 'Stress Rate', Icons.mood_bad, 'High');
  }
}

// Tela de Passos
class StepsPage extends StatelessWidget {
  const StepsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDetailPage(
        context, 'Steps', Icons.directions_walk, '1000 Steps');
  }
}

// Tela de Temperatura
class TemperaturePage extends StatelessWidget {
  const TemperaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDetailPage(context, 'Temperature', Icons.thermostat, '40°C');
  }
}

// Template para páginas detalhadas
Widget _buildDetailPage(
    BuildContext context, String title, IconData icon, String value) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Color(0xFFD90429)),
          SizedBox(height: 16),
          Text(value,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}
