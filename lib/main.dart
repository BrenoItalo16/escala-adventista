import 'package:escala_adventista/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Função para adicionar um documento na coleção "songs"
  await addSongToCollection();

  runApp(const MyApp());
}

Future<void> addSongToCollection() async {
  // Acessa a coleção "songs" e adiciona um documento exemplo
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');
  await songs.add({
    'title': 'Exemplo de Música',
    'artist': 'Artista Desconhecido',
    'duration': 181, // Duração em segundos
  });
  print("Documento adicionado à coleção 'songs'.");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escala Adventista',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 89, 0)),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Escala Adventista'),
        ),
        body: Center(
          child: TextButton(
            onPressed: () {
              addSongToCollection();
            },
            child: const Text('Testar Firebase'),
          ),
        ),
      ),
    );
  }
}
