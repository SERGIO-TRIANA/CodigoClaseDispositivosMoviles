// ============================================================
// MODELO: Pokemon
// Representa los datos que nos devuelve la PokéAPI
// ============================================================

// Los imports SIEMPRE van al inicio del archivo en Dart
import 'package:flutter/material.dart' show Color;

class Pokemon {
  final int id;
  final String nombre;
  final List<String> tipos; // Ej: ["fire", "flying"]
  final List<Stat> estadisticas; // HP, Ataque, Defensa, etc.
  final int altura; // En decímetros (se convierte a metros)
  final int peso; // En hectogramos (se convierte a kg)

  Pokemon({
    required this.id,
    required this.nombre,
    required this.tipos,
    required this.estadisticas,
    required this.altura,
    required this.peso,
  });

  // ---- URLs de las imágenes ----

  // Imagen pixel art (sprite frontal oficial)
  String get urlPixelArt =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

  // Imagen pixel art shiny (alternativa dorada)
  String get urlPixelArtShiny =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/$id.png';

  // Imagen oficial de alta calidad (para fondo decorativo)
  String get urlOficial =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

  // Altura en metros (la API devuelve decímetros)
  double get alturaMetros => altura / 10;

  // Peso en kilogramos (la API devuelve hectogramos)
  double get pesoKg => peso / 10;

  // ============================================================
  // FACTORY: crea un Pokemon a partir del JSON de la API
  // ============================================================
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // Extraemos los tipos: json['types'] es una lista de objetos
    final tipos = (json['types'] as List)
        .map((t) => t['type']['name'] as String)
        .toList();

    // Extraemos las estadísticas base
    final stats = (json['stats'] as List)
        .map((s) => Stat(
              nombre: s['stat']['name'] as String,
              valor: s['base_stat'] as int,
            ))
        .toList();

    return Pokemon(
      id: json['id'] as int,
      nombre: json['name'] as String,
      tipos: tipos,
      estadisticas: stats,
      altura: json['height'] as int,
      peso: json['weight'] as int,
    );
  }
}

// ============================================================
// MODELO: Stat (estadística individual)
// Ej: { nombre: "hp", valor: 45 }
// ============================================================
class Stat {
  final String nombre;
  final int valor;

  Stat({required this.nombre, required this.valor});

  // Nombre bonito para mostrar en la UI
  String get nombreLegible {
    const nombres = {
      'hp': 'HP',
      'attack': 'Ataque',
      'defense': 'Defensa',
      'special-attack': 'Sp. Ataque',
      'special-defense': 'Sp. Defensa',
      'speed': 'Velocidad',
    };
    return nombres[nombre] ?? nombre;
  }

  // Color de la barra según el valor (bajo=rojo, medio=amarillo, alto=verde)
  // ignore: library_private_types_in_public_api
  static dynamic colorPorValor(int valor) {
    if (valor < 50) return const Color(0xFFE74C3C);
    if (valor < 80) return const Color(0xFFF39C12);
    return const Color(0xFF27AE60);
  }
}
