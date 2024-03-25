
import 'package:flutter/material.dart';
import 'package:mapsense/ViewModel/home_view_model.dart';
import 'package:provider/provider.dart';
import 'View/home_page.dart';


// ? CODE: Uday kiran Begari
// github: Uday-kiran9147

void main() {
  runApp( ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'mapsense',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainView(),
    );
  }
}

