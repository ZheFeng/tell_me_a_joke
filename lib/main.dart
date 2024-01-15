import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Tell me a joke',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class RemoteJoke {
  final String message;

  const RemoteJoke({
    required this.message,
  });

  factory RemoteJoke.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'message': String message,
      } =>
        RemoteJoke(
          message: message,
        ),
      _ => throw const FormatException('Failed to load joke.'),
    };
  }

  static Future<RemoteJoke> getRemoteJoke() async {
    debugPrint('start request');
    final res = await http.get(Uri.parse('http://localhost:3000/api/gpt'));
    debugPrint(res.body);

    if (res.statusCode == 200) {
      return RemoteJoke.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load joke');
    }
  }
}

class MyAppState extends ChangeNotifier {
  String joke = '';
  bool loading = false;

  Future<void> getJoke() async {
    // before send request, show loading
    loading = true;
    notifyListeners();

    // call api
    final remoteJoke = await RemoteJoke.getRemoteJoke();

    // stop loading, show joke
    loading = false;
    joke = remoteJoke.message;
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var card = appState.loading
        ? const Text('loading...')
        : JokeCard(joke: appState.joke);
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: card,
              ),
              ElevatedButton(
                  onPressed: () {
                    appState.getJoke();
                  },
                  child: const Text('Tell me a joke')),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JokeCard extends StatelessWidget {
  const JokeCard({
    super.key,
    required this.joke,
  });

  final String joke;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            joke,
            style: theme.textTheme.bodyLarge,
          ),
        ));
  }
}
