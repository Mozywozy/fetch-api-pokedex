import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../services/poke_service.dart';
import '../models/pokemon.dart';
import 'pokemon_detail_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Pokemon>> pokemonList;
  List<Pokemon> filteredPokemonList = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    pokemonList = ApiService().fetchPokemonList();
  }

  void _filterPokemon(String query, List<Pokemon> pokemonList) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredPokemonList = pokemonList
          .where((pokemon) => pokemon.name.toLowerCase().contains(searchQuery))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menghapus AppBar untuk membuat tampilan full-screen
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.redAccent, Colors.deepOrangeAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<Pokemon>>(
          future: pokemonList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No Pokemon found',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              final pokemonList = snapshot.data!;
              if (searchQuery.isEmpty) {
                filteredPokemonList = pokemonList;
              }

              return Column(
                children: [
                  const SizedBox(height: 50),
                  Text(
                    'Pokedex',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Pokemon...',
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.3),
                        hintStyle: const TextStyle(color: Colors.white),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onChanged: (query) {
                        _filterPokemon(query, pokemonList);
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: StaggeredGridView.countBuilder(
                        crossAxisCount: 4,
                        itemCount: filteredPokemonList.length,
                        itemBuilder: (context, index) {
                          final pokemon = filteredPokemonList[index];
                          return _buildPokemonCard(pokemon);
                        },
                        staggeredTileBuilder: (int index) =>
                            const StaggeredTile.fit(2),
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildPokemonCard(Pokemon pokemon) {
    final pokemonId = getPokemonId(pokemon.url);
    final imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonId.png';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailPage(pokemon: pokemon, imageUrl: imageUrl),
          ),
        );
      },
      child: Hero(
        tag: pokemon.name,
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.white.withOpacity(0.8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  imageUrl,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                pokemon.name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  String getPokemonId(String url) {
    final uri = Uri.parse(url);
    return uri.pathSegments[uri.pathSegments.length - 2];
  }
}
