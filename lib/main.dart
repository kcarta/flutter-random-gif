// main.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const GiphyApp());
}

class GiphyApp extends StatelessWidget {
  const GiphyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Giphy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const RandomGifPage(),
    );
  }
}

class RandomGifPage extends StatefulWidget {
  const RandomGifPage({super.key});

  @override
  State<RandomGifPage> createState() => _RandomGifPageState();
}

class _RandomGifPageState extends State<RandomGifPage> {
  String? currentGifUrl;
  bool isLoading = false;
  final TextEditingController _tagController = TextEditingController();
  String? apiKey;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    try {
      final String key = await rootBundle.loadString('assets/api_key');
      setState(() {
        apiKey = key.trim();
      });
      // Load initial random GIF
      _fetchRandomGif();
    } catch (e) {
      print('Error loading API key: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading API key')),
      );
    }
  }

  Future<void> _fetchRandomGif() async {
    if (apiKey == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final tag =
          _tagController.text.isNotEmpty ? '&tag=${_tagController.text}' : '';
      final response = await http.get(
        Uri.parse('http://api.giphy.com/v1/gifs/random?api_key=$apiKey$tag'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          currentGifUrl = data['data']['images']['original']['url'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load GIF');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error fetching GIF')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Giphy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tagController,
              decoration: const InputDecoration(
                labelText: 'Enter tag (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchRandomGif,
              child: const Text('Get Random GIF'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : currentGifUrl != null
                        ? Image.network(
                            currentGifUrl!,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Text('Error loading image');
                            },
                          )
                        : const Text('No GIF loaded'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }
}
