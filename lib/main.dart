import 'package:flutter/material.dart';
import 'package:odalvinoeventoapp/presentations/screens/home/car_shop.dart';
import 'package:odalvinoeventoapp/presentations/screens/home/home.dart';
import 'package:odalvinoeventoapp/presentations/screens/inicio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Oda al Vino',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        

      ),
      home: const Presentations(),
      routes:{
        '/home': (context)=>  const HomeScreen() ,
        '/car-shop': (context) => const CarShopScreen()
      } ,
    );
  }
}

