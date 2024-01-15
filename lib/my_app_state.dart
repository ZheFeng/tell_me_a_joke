import 'package:flutter/material.dart';
import 'package:tell_me_a_joke/remote_joke.dart';

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
