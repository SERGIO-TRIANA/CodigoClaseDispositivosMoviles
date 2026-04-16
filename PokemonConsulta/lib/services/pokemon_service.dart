// ============================================================
// SERVICIO: PokemonService
// Maneja todas las llamadas a la PokéAPI
// URL base: https://pokeapi.co/api/v2/
// ============================================================

import 'dart:convert';           // Para decodificar JSON
import 'package:http/http.dart' as http;  // Para hacer peticiones HTTP
import '../models/pokemon.dart';

class PokemonService {
  // URL base de la API (constante, nunca cambia)
  static const String _baseUrl = 'https://pokeapi.co/api/v2';

  // ============================================================
  // Busca un Pokémon por nombre o número
  // Devuelve un Pokemon o lanza una excepción si no existe
  // ============================================================
  static Future<Pokemon> buscarPokemon(String nombreOId) async {
    // Convertimos a minúsculas porque la API es case-sensitive
    final query = nombreOId.toLowerCase().trim();

    // Construimos la URL: ej. https://pokeapi.co/api/v2/pokemon/pikachu
    final url = Uri.parse('$_baseUrl/pokemon/$query');

    // Hacemos la petición GET (await = esperamos la respuesta)
    final respuesta = await http.get(url);

    // Verificamos que la respuesta sea exitosa (código 200)
    if (respuesta.statusCode == 200) {
      // Decodificamos el JSON y creamos el objeto Pokemon
      final json = jsonDecode(respuesta.body) as Map<String, dynamic>;
      return Pokemon.fromJson(json);
    } else if (respuesta.statusCode == 404) {
      throw Exception('Pokémon "$nombreOId" no encontrado');
    } else {
      throw Exception('Error de servidor: ${respuesta.statusCode}');
    }
  }
}
