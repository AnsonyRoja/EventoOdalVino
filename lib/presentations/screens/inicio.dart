
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:odalvinoeventoapp/presentations/screens/home/home.dart';
import 'package:odalvinoeventoapp/presentations/screens/home/qr_scanner/qr_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class Presentations extends StatefulWidget {
  const Presentations({super.key});

  @override
  State<Presentations> createState() => _PresentationsState();
}

class _PresentationsState extends State<Presentations> {
    TextEditingController couponController = TextEditingController();

   

  void _checkPermissions() async {
      var cameraStatus = await Permission.camera.status;

     if (!cameraStatus.isGranted) {
             await Permission.camera.request();
       }

  }


  @override
  void initState() {
    _checkPermissions();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final mediaScreen = MediaQuery.of(context).size.width * 0.9;
    final heightScreen = MediaQuery.of(context).size.height * 0.9; 
    String cupon = "07XF59P";

    return GestureDetector(
      onTap: () {

          FocusScope.of(context).requestFocus(FocusNode());

      } ,
      child: Scaffold(
      
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/FONDO.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.transparent, // Hace que la AppBar sea transparente
                elevation: 0,
                actions:  [
                  
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: () async {

                           String? barCode =  await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => QRScannerScreen(),
                          ),
                        );

                        if (barCode != null) {
                          setState(() {
                            couponController.text = barCode;
                          });
                        }
                        } ,
                        child: Image.asset('lib/assets/QR.png')),
                    ),
                  
                  ],
              ),
              body: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                      
                    children: [
                      Image.asset('lib/assets/logo@3x.png', width: 110,),
                      SizedBox(height: heightScreen *0.1,),
                      const Text(
                        'Cupón',
                        style: TextStyle(color: Colors.white, fontFamily: 'Neuton ExtraBold', fontSize: 45),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: heightScreen * 0.05,),
                       Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           const Padding(
                             padding: EdgeInsets.all(2.0),
                             child: Text(
                               'Código do voucher',
                               style: TextStyle(color: Color(0XFFFFFFFF), fontFamily: 'AlegreyaSans Regular'),
                               
                               textAlign: TextAlign.center,
                             ),
                           ),
                          Container(
                            width: mediaScreen,
                            child: TextField(
                              style: const TextStyle(color: Colors.white),
                              controller: couponController,
                              decoration: InputDecoration(
                              border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white!), // Color del borde cuando el TextField está habilitado y no enfocado
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white), // Color del borde cuando el TextField está enfocado
                    borderRadius: BorderRadius.circular(15.0),
                  ),

                                
                                hintText: 'Escreva aqui...',
                                hintStyle: const TextStyle(color: Colors.grey) ,
                              
                              ),
                            ),
                          ),
                         ],
                       ),
                      SizedBox(height: heightScreen * 0.1,),
                      ElevatedButton(
                        style: const ButtonStyle( backgroundColor: WidgetStatePropertyAll( Color(0XFF9FAADE)),  elevation: WidgetStatePropertyAll<double>(5),shadowColor: WidgetStatePropertyAll(Colors.black)   ),
                        onPressed: () {
                         if (cupon == couponController.text) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    } else if (couponController.text != "") {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            title: Text('Error'),
                            content: Text('Ocurrio un error al procesar su cupon'),
                          );
                        },
                      );
                    }
                        
                      } , child: const Text('Aceitar', style: TextStyle(fontFamily: 'AlegreyaSans Bold', fontSize: 18, color: Colors.black),)),

                      SizedBox(height: heightScreen * 0.1,)
                    
                    ],
                  ),
                ),
              ),
            
            ),
          ],
        ),
      ),
    );
  }
}
