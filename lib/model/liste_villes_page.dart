import 'package:flutter/material.dart';
import '../screen/meteo_detail_page.dart';

class ListeVillesPage extends StatelessWidget {
  const ListeVillesPage({super.key});

  final List<String> villes = const [
    'Paris',
    'Londres',
    'Tokyo',
    'New York',
    'Sydney'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choisissez une ville')),
      body: ListView.builder(
        itemCount: villes.length,
        itemBuilder: (context, index) {
          final ville = villes[index];
          return ListTile(
            title: Text(ville),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MeteoDetailPage(cityName: ville),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
