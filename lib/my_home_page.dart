import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tell_me_a_joke/joke_card.dart';
import 'package:tell_me_a_joke/my_app_state.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    var widgets = <Widget>[];
    if (appState.joke.isNotEmpty || appState.loading) {
      var card = appState.loading
          ? const Text('loading...')
          : JokeCard(joke: appState.joke);
      widgets.add(Padding(
        padding: const EdgeInsets.all(40.0),
        child: card,
      ));
    }
    widgets.add(ElevatedButton(
        onPressed: () {
          appState.getJoke();
        },
        child: const Text('Tell me a joke')));
    widgets.add(const SizedBox(
      height: 20,
    ));

    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: widgets,
          ),
        ),
      ),
    );
  }
}
