// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        var appState = AppState();
        appState.init();
        return appState;
      },
      child: MaterialApp(
        title: 'Namer App',
        theme: _buildTheme(),
        home: MyHomePage(),
      ),
    );
  }
}

ThemeData _buildTheme() {
  var baseTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
  );

  return baseTheme.copyWith(
    textTheme: GoogleFonts.latoTextTheme(baseTheme.textTheme)
  );
}
