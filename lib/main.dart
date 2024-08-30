import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:odalvinoeventoapp/presentations/screens/home/car_shop.dart';
import 'package:odalvinoeventoapp/presentations/screens/home/home.dart';
import 'package:odalvinoeventoapp/presentations/screens/home/providers/product_provider.dart';
import 'package:odalvinoeventoapp/presentations/screens/inicio.dart';
import 'package:provider/provider.dart';

late final ValueNotifier<String> carShopNotifier;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  

  carShopNotifier = ValueNotifier(localStorage.getItem('carShop')?? '');

  carShopNotifier.addListener((){

    localStorage.setItem('carShop', "[]");

  });

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_)=>ProductProvider())
    ],
    child: const MyApp()));
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

