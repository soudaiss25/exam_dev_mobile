import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:lottie/lottie.dart';

import '../api/weather_api.dart';
import '../models/weather_data.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  final List<String> _cities = ['Paris', 'New York', 'Tokyo', 'London', 'Sydney'];
  final List<WeatherData> _weatherData = [];
  bool _isLoading = true;
  int _messageIndex = 0;
  final List<String> _loadingMessages = [
    'Nous téléchargeons les données...',
    'C\'est presque fini...',
    'Plus que quelques secondes avant d\'avoir le résultat...'
  ];
  late Timer _messageTimer;
  late Timer _apiCallTimer;
  final String _apiKey = 'e93fb604a47d4f3ab8b154125251303';
  late WeatherApiClient _apiClient;

  @override
  void initState() {
    super.initState();

    // Initialisation du client API
    final dio = Dio();
    _apiClient = WeatherApiClient(dio);

    // Configuration de l'animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15), // Durée totale de la jauge
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Démarrage de l'animation
    _animationController.forward();

    // Écouteur pour détecter quand l'animation est terminée
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isLoading = false;
        });
        _messageTimer.cancel();
        _apiCallTimer.cancel();
      }
    });

    // Timer pour changer le message de chargement
    _messageTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _messageIndex = (_messageIndex + 1) % _loadingMessages.length;
      });
    });

    // Timer pour appeler l'API météo
    _apiCallTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _fetchWeatherData();
    });
  }

  // Méthode pour récupérer les données météo
  Future<void> _fetchWeatherData() async {
    if (_weatherData.length < _cities.length) {
      try {
        final city = _cities[_weatherData.length];
        final apiResponse = await _apiClient.getCurrentWeather(_apiKey, city);
        final weatherData = WeatherData.fromApiResponse(apiResponse);

        setState(() {
          _weatherData.add(weatherData);
        });
      } catch (e) {
        debugPrint('Erreur lors de la récupération des données: $e');
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _messageTimer.cancel();
    _apiCallTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(
          'WeatherApp',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
        backgroundColor: Colors.blue.shade100,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: _isLoading ? _buildLoadingScreen() : _buildResultScreen(),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/animations/weather.json',
          width: 150,
          height: 150,
        ),
        const SizedBox(height: 20),
        Text(
          _loadingMessages[_messageIndex],
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: Colors.blue.shade700,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Column(
                children: [
                  LinearProgressIndicator(
                    value: _progressAnimation.value,
                    backgroundColor: Colors.blue.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
                    minHeight: 15,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${(_progressAnimation.value * 100).toInt()}%',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Villes récupérées: ${_weatherData.length}/${_cities.length}',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.blueGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildResultScreen() {
    return Column(
      children: [
        // Animation "BOOM"
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 1),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Text(
                'BOOM! 🎉 🎊',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        Text(
          'Résultats météo',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.blue.shade800,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: _weatherData.length,
            itemBuilder: (context, index) {
              final weather = _weatherData[index];
              return _buildWeatherCard(weather);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherCard(WeatherData weather) {
    // Définir la couleur en fonction de la température
    Color tempColor = Colors.orange;
    if (weather.temperature < 10) {
      tempColor = Colors.blue.shade700;
    } else if (weather.temperature < 20) {
      tempColor = Colors.green.shade600;
    } else if (weather.temperature < 30) {
      tempColor = Colors.orange;
    } else {
      tempColor = Colors.red;
    }

    // Définir l'icône en fonction de la condition
    IconData weatherIcon = Icons.sunny;
    if (weather.condition.toLowerCase().contains('nuageux')) {
      weatherIcon = Icons.cloud;
    } else if (weather.condition.toLowerCase().contains('pluvi')) {
      weatherIcon = Icons.water_drop;
    } else if (weather.condition.toLowerCase().contains('orag')) {
      weatherIcon = Icons.thunderstorm;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        title: Text(
          weather.city,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.blue.shade900,
          ),
        ),
        subtitle: Text(
          '${weather.temperature.toStringAsFixed(1)}°C - ${weather.condition}',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: tempColor,
          ),
        ),
        leading: Icon(
          weatherIcon,
          size: 36,
          color: tempColor,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildWeatherDetailRow('Humidité', '${weather.humidity}%', Icons.water),
                const SizedBox(height: 10),
                _buildWeatherDetailRow('Vent', '${weather.windSpeed.toStringAsFixed(1)} km/h', Icons.air),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade700),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey.shade700,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.blue.shade900,
          ),
        ),
      ],
    );
  }
}