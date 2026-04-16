// ============================================================
// PANTALLA PRINCIPAL: PokedexScreen
// Contiene la barra de búsqueda, la imagen pixel art
// y la card de estadísticas
// ============================================================

import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../utils/tipo_colores.dart';
import '../widgets/pixel_art_image.dart';
import '../widgets/stats_card.dart';
import '../widgets/tipo_badge.dart';

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({super.key});

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  // ---- ESTADO ----
  final TextEditingController _searchController = TextEditingController();

  // null = aún no se ha buscado nada
  Pokemon? _pokemon;

  // true = hay una petición en curso
  bool _cargando = false;

  // null = sin error
  String? _error;

  // Pokémons sugeridos para búsqueda rápida
  final List<Map<String, String>> _sugerencias = [
    {'nombre': 'pikachu', 'emoji': '⚡'},
    {'nombre': 'charizard', 'emoji': '🔥'},
    {'nombre': 'mewtwo', 'emoji': '🔮'},
    {'nombre': 'gengar', 'emoji': '👻'},
    {'nombre': 'eevee', 'emoji': '⭐'},
    {'nombre': 'snorlax', 'emoji': '💤'},
  ];

  // ============================================================
  // Ejecuta la búsqueda llamando al servicio
  // ============================================================
  Future<void> _buscar(String query) async {
    if (query.trim().isEmpty) return;

    // Actualizamos estado: empezamos a cargar, limpiamos errores
    setState(() {
      _cargando = true;
      _error = null;
      _pokemon = null;
    });

    try {
      // Llamada async al servicio (await pausa hasta tener respuesta)
      final pokemon = await PokemonService.buscarPokemon(query);

      // Éxito: guardamos el pokemon
      setState(() {
        _pokemon = pokemon;
        _cargando = false;
      });
    } catch (e) {
      // Error: guardamos el mensaje de error
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _cargando = false;
      });
    }
  }

  // ============================================================
  // BUILD: construye la pantalla
  // ============================================================
  @override
  Widget build(BuildContext context) {
    // Color de fondo dinámico según el tipo del Pokémon actual
    final colorFondo = _pokemon != null
        ? colorFondoPokemon(_pokemon!.tipos)
        : Colors.grey.shade100;

    return Scaffold(
      // AnimatedContainer anima cambios de color suavemente
      backgroundColor: Colors.transparent,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: colorFondo,
        child: SafeArea(
          child: Column(
            children: [
              // ---- HEADER ----
              _buildHeader(),

              // ---- BARRA DE BÚSQUEDA ----
              _buildSearchBar(),

              // ---- CHIPS DE SUGERENCIAS ----
              _buildSugerencias(),

              // ---- CONTENIDO PRINCIPAL ----
              Expanded(
                child: _buildContenido(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Header con título ----
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          // Ícono pokeball decorativo
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Center(
              child:
                  Icon(Icons.catching_pokemon, color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pokédex',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Busca tu Pokémon favorito',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---- Barra de búsqueda ----
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          textInputAction: TextInputAction.search,
          onSubmitted: _buscar, // Busca al presionar Enter/Buscar
          decoration: InputDecoration(
            hintText: 'pikachu, 25, charizard...',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _pokemon = null;
                        _error = null;
                      });
                    },
                  )
                : null,
            border: InputBorder.none, // Sin borde (ya tiene el Container)
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          // Actualizamos para mostrar/ocultar el botón clear
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }

  // ---- Chips de búsqueda rápida ----
  Widget _buildSugerencias() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal, // Lista horizontal
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _sugerencias.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final s = _sugerencias[index];
          return ActionChip(
            label: Text('${s['emoji']} ${s['nombre']}'),
            onPressed: () {
              // Al tocar un chip, ponemos el texto y buscamos
              _searchController.text = s['nombre']!;
              _buscar(s['nombre']!);
            },
            backgroundColor: Colors.white,
            elevation: 2,
          );
        },
      ),
    );
  }

  // ---- Contenido según el estado actual ----
  Widget _buildContenido() {
    // Estado: cargando
    if (_cargando) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Buscando en la Pokédex...'),
          ],
        ),
      );
    }

    // Estado: error
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('😵', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Verifica el nombre o número e intenta de nuevo',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    // Estado: sin búsqueda aún
    if (_pokemon == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🔍', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'Escribe un nombre o número\npara buscar un Pokémon',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    // Estado: Pokémon encontrado → mostramos la info
    return _buildPokemonInfo(_pokemon!);
  }

  // ---- Tarjeta de información del Pokémon ----
  Widget _buildPokemonInfo(Pokemon pokemon) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // ---- NÚMERO Y NOMBRE ----
          Text(
            '#${pokemon.id.toString().padLeft(3, '0')}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
              letterSpacing: 2,
            ),
          ),
          Text(
            // toUpperCase() convierte a mayúsculas
            pokemon.nombre.toUpperCase(),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),

          const SizedBox(height: 8),

          // ---- TIPOS ----
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: pokemon.tipos
                .map((tipo) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TipoBadge(tipo: tipo),
                    ))
                .toList(),
          ),

          const SizedBox(height: 24),

          // ---- IMAGEN PIXEL ART ----
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color:
                      colorDeTipo(pokemon.tipos.first).withValues(alpha: 0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: PixelArtImage(
              url: pokemon.urlPixelArt,
              size: 180,
            ),
          ),

          const SizedBox(height: 20),

          // ---- ALTURA Y PESO ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoChip('📏 Altura', '${pokemon.alturaMetros} m'),
              _buildInfoChip('⚖️ Peso', '${pokemon.pesoKg} kg'),
            ],
          ),

          const SizedBox(height: 20),

          // ---- CARD DE ESTADÍSTICAS ----
          StatsCard(
            estadisticas: pokemon.estadisticas,
            tipos: pokemon.tipos,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ---- Chip de información (altura/peso) ----
  Widget _buildInfoChip(String label, String valor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Text(
            valor,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
