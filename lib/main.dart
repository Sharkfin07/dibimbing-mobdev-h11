import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
// import './widgets/video_view.dart';

// Top-level AudioPlayer used by the simple demo button below.
final AudioPlayer player = AudioPlayer();

void main() {
  runApp(const MainApp());
}

class Product {
  final int id;
  final String name;
  final int price;

  Product({required this.id, required this.name, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as int,
    name: json['name'] as String,
    price: json['price'] as int,
  );
}

Future<List<Product>> loadProducts() async {
  final data = await rootBundle.loadString('assets/data/products.json');
  final List<dynamic> jsonList = jsonDecode(data) as List<dynamic>;
  return jsonList
      .map((item) => Product.fromJson(item as Map<String, dynamic>))
      .toList();
}

Widget productViewer() {
  return Expanded(
    child: FutureBuilder<List<Product>>(
      future: loadProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products found'));
        } else {
          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('Rp ${product.price}'),
              );
            },
          );
        }
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                // * IMG Test
                Image.asset("assets/images/ui.jpg"),

                // * Font Test
                Text(
                  'Hello, I am from Google Fonts!',
                  style: GoogleFonts.youngSerif(),
                ),
                Text(
                  'Hello, I am from local!',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // * JSON Test
                productViewer(),

                // * Sound Test
                ElevatedButton(
                  onPressed: () async => player.play(
                    UrlSource(
                      'https://soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
                    ),
                  ),
                  child: Text("Play"),
                ),

                // * Video Test
                // VideoView(),

                // * SVG Test
                SvgPicture.asset('assets/icons/humberger-svgrepo-com.svg'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
