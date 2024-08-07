
import 'package:flutter/material.dart';






  class CarShopScreen extends StatefulWidget {
    const CarShopScreen({super.key});
  
    @override
    State<CarShopScreen> createState() => _CarShopScreenState();
  }
  
  class _CarShopScreenState extends State<CarShopScreen> {
    // Controladores de texto

    // Variables

    bool isSelectedHomeModule = false;
    bool isSelectedCarShopingModule = true; 



    @override
    Widget build(BuildContext context) {

      final mediaScreen = MediaQuery.of(context).size.width * 0.9;
      final heightScreen = MediaQuery.of(context).size.height * 0.9;
      
      return Scaffold(

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
                  
             GestureDetector(
              onTap: () {

                FocusScope.of(context).unfocus();

              } ,
               child: Scaffold(
                           backgroundColor: Colors.transparent,
                           appBar: PreferredSize(
                
                preferredSize: const Size.fromHeight(150),
                child: Column(
               
                    children: [
                      const SizedBox(height: 70,),

                           Text('Carrinho de compras', style: TextStyle(fontFamily: 'Neuton ExtraBold' ,color: Colors.white, fontSize: 35),),

                      
                    ],
                
                ),
                
                           ) ,
               
                           body: Center(
                child: Container(
                  width: mediaScreen,
                  child: Column(
                      
                    children: [
                   
                  
                  ],),
                ),
                           ), 

              bottomNavigationBar: Container(
              
                width: mediaScreen,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [

                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 7,
                      spreadRadius: 2,

                    ),

                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 60, // Altura de la barra de navegación
                        color: Colors.white,
                        child: Center(
                          child: GestureDetector(
                            onTap: (){
                                setState(() {
                                  isSelectedHomeModule = true;
                                  isSelectedCarShopingModule = false;
                                });
                          Navigator.pushNamed(context, '/home');

                            }, child: Image.asset('lib/assets/home@2x.png', width: 50, color: isSelectedHomeModule ? Color(0xFF053452): Colors.grey,),),
                        ),
                      ),
                      Container(
                    
                        child: GestureDetector(
                          onTap: () {
                               setState(() {
                                  isSelectedHomeModule = false;
                                  isSelectedCarShopingModule = true;
                                });
                          Navigator.pushNamed(context, '/car-shop');

                          },
                          child: Image.asset('lib/assets/carrito@2x.png', width: 50, color: isSelectedCarShopingModule ? Color(0xFF053452) : Colors.grey,),
                        ),
                      ),
                    ],
                  ),
                ),
              ),               
                           ),
             )

              ],
            ),



      );
    }
  }












