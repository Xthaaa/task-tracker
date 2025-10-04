import 'package:flutter/material.dart';
import 'package:practice_app/ash.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 135, 122, 10),
        body: Ash(),
      ),
    ),
  );
}
