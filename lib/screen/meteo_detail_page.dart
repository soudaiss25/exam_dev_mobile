import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiKey = dotenv.env['OPENWEATHER_API_KEY'];

class MeteoDetailPage extends StatefulWidget {
  final String cityName;
  const MeteoDetailPage({super.key, required this.cityName});

  @override
  State<MeteoDetailPage> createState() => _MeteoDetailPageState();
}

class _MeteoDetailPageState extends State<MeteoDetailPage> {
  Map<String, dynamic>? data;
  bool isLoading = true;
  String? error;
  LatLng? location;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final response = await Dio().get(
        'https://api.openweathermap.org/data/2.5/weather',
        queryParameters: {
          'q': widget.cityName,
          'appid': apiKey,
          'units': 'metric',
          'lang': 'fr'
        },
      );
      setState(() {
        data = response.data;
        final coord = data!["coord"];
        location = LatLng(coord["lat"], coord["lon"]);
        isLoading = true;
      });
    } catch (e) {
      setState(() {
        error = "Erreur de chargement des données météo.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.cityName)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error!),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: fetchWeather,
              child: const Text("Réessayer"),
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Température : ${data!['main']['temp']} °C",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              "Description : ${data!['weather'][0]['description']}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Humidité : ${data!['main']['humidity']}%",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            if (location != null)
              SizedBox(
                height: 200,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: location!,
                    zoom: 10,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('ville'),
                      position: location!,
                    ),
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
