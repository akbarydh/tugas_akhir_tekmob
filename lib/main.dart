import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // ✅ hasil dari flutterfire configure
import 'providers/tontonan_provider.dart';
import 'screens/tontonan_list_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
