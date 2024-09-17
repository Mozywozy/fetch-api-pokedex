import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex_app/models/pokemon.dart';

class ApiService {
  static const String baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  Future<List<Pokemon>> fetchPokemonList() async {
    final response = await http.get(Uri.parse('$baseUrl?limit=100'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['results'] as List)
          .map((pokemon) => Pokemon.fromJson(pokemon))
          .toList();
    } else {
      throw Exception('Failed to load Pokemon');
    }
  }
}
