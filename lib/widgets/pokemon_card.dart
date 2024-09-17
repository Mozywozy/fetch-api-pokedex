// import 'package:flutter/material.dart';
// import '../models/pokemon.dart';

// class PokemonCard extends StatelessWidget {
//   final Pokemon pokemon;
//   final VoidCallback onTap;

//   PokemonCard({required this.pokemon, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         elevation: 5,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.network(pokemon.imageUrl, height: 100, fit: BoxFit.cover),
//             SizedBox(height: 10),
//             Text(
//               pokemon.name.toUpperCase(),
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
