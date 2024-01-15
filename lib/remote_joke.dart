import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
