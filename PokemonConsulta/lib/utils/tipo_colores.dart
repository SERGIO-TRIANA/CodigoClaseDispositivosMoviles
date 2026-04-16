// ============================================================
// HELPERS: Colores y utilidades por tipo de Pokémon
// ============================================================

import 'package:flutter/material.dart';

// Mapa de colores oficiales por tipo de Pokémon
const Map<String, Color> tipoColores = {
  'fire': Color(0xFFFF6B35),
  'water': Color(0xFF4FC3F7),
  'grass': Color(0xFF66BB6A),
  'electric': Color(0xFFFFD54F),
  'psychic': Color(0xFFEC407A),
  'ice': Color(0xFF80DEEA),
  'dragon': Color(0xFF7E57C2),
  'dark': Color(0xFF546E7A),
  'fairy': Color(0xFFF48FB1),
  'fighting': Color(0xFFEF5350),
  'flying': Color(0xFF90CAF9),
  'poison': Color(0xFFAB47BC),
  'ground': Color(0xFFBCAAA4),
  'rock': Color(0xFFAFA77E),
  'bug': Color(0xFF9CCC65),
  'ghost': Color(0xFF5C6BC0),
  'steel': Color(0xFF90A4AE),
  'normal': Color(0xFFBDBDBD),
};

// Devuelve el color de un tipo (o gris si no se conoce)
Color colorDeTipo(String tipo) {
  return tipoColores[tipo] ?? Colors.grey;
}

// Color de fondo de la pantalla basado en el tipo principal
Color colorFondoPokemon(List<String> tipos) {
  if (tipos.isEmpty) return Colors.grey.shade100;
  return colorDeTipo(tipos.first).withValues(alpha: 0.15);
}

// Emoji del tipo (decorativo)
const Map<String, String> tipoEmoji = {
  'fire': '🔥',
  'water': '💧',
  'grass': '🌿',
  'electric': '⚡',
  'psychic': '🔮',
  'ice': '❄️',
  'dragon': '🐉',
  'dark': '🌑',
  'fairy': '✨',
  'fighting': '🥊',
  'flying': '🌪️',
  'poison': '☠️',
  'ground': '🌍',
  'rock': '🪨',
  'bug': '🐛',
  'ghost': '👻',
  'steel': '⚙️',
  'normal': '⭐',
};
