import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'boleta.dart';
import 'itemCard.dart';
import 'boleta_detail_page.dart';
import 'services/boleta_service.dart';

class BoletaScreen extends StatefulWidget {
  const BoletaScreen({super.key});

  @override
  State<BoletaScreen> createState() => _BoletaScreenState();
}

class _BoletaScreenState extends State<BoletaScreen> {
  int? favoriteId;

  late BoletaService _service;
  late Future<List<Boleta>> _futureBoletas;

  @override
  void initState() {
    super.initState();

    // En la version final cargamos automaticamente
    // cuando nace la pantalla.
    // URL relativa: se resuelve contra el mismo origen de la app,
    // asi no depende del puerto ni la bloquea el CORS del navegador.
    _service = BoletaService('boletas.json');
    _futureBoletas = _service.getBoletas();
    loadFavorite();
  }

  void openBoletaDetail(Boleta boleta) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BoletaDetailPage(boleta: boleta)),
    );
  }

  Future<void> saveFavorite() async {
    final prefs = await SharedPreferences.getInstance();

    if (favoriteId == null) {
      await prefs.remove('favoriteId');
    } else {
      await prefs.setInt('favoriteId', favoriteId!);
    }
  }

  Future<void> loadFavorite() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      favoriteId = prefs.getInt('favoriteId');
    });
  }

  void toggleFavorite(int boletaId) {
    setState(() {
      favoriteId = favoriteId == boletaId ? null : boletaId;
    });

    saveFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Mis boletas'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  // ------------------------------
  // ESTADO -> INTERFAZ
  // ------------------------------

  Widget _buildBody() {
    return FutureBuilder<List<Boleta>>(
      future: _futureBoletas,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off_outlined, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'No pudimos cargar las boletas',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _futureBoletas = _service.getBoletas();
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        final boletas = snapshot.data ?? [];

        if (boletas.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.confirmation_number_outlined, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'Todavía no hay boletas disponibles',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: boletas.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tu próxima boleta',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${boletas.length} boletas para explorar',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Toca una tarjeta para ver más o marca tu favorita con la estrella.',
                    ),
                  ],
                ),
              );
            }

            final boleta = boletas[index - 1];
            final bool isFavorite = boleta.id == favoriteId;

            return ItemCard(
              boleta: boleta,
              isFavorite: isFavorite,
              onFavoriteTap: () {
                toggleFavorite(boleta.id);
              },
              onTap: () {
                openBoletaDetail(boleta);
              },
            );
          },
        );
      },
    );
  }
}
