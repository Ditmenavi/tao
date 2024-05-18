import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.getFont('Roboto Flex').fontFamily,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        fontFamily: GoogleFonts.getFont('Roboto Flex').fontFamily,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      title: 'Flutter Demo',
      home: const MyHome(),
    );
  }
}
