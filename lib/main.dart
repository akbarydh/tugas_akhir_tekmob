// File: lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/tontonan_provider.dart';
import 'screens/tontonan_list_screen.dart';

void main() {
  runApp(const PlayLaterApp());
}

class PlayLaterApp extends StatelessWidget {
  const PlayLaterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TontonanProvider(),
      child: MaterialApp(
        title: 'Playlater',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: TontonanListScreen(),
      ),
    );
  }
}
