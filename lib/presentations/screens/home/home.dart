
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:localstorage/localstorage.dart';
import 'package:odalvinoeventoapp/presentations/backend/get_products_http.dart';
import 'package:odalvinoeventoapp/presentations/screens/home/hardcode_products.dart';
import 'package:odalvinoeventoapp/presentations/screens/home/qr_scanner/qr_scanner.dart';






  class HomeScreen extends StatefulWidget {
    const HomeScreen({super.key});
  
    @override
    State<HomeScreen> createState() => _HomeScreenState();
  }
  
  class _HomeScreenState extends State<HomeScreen> {
    // Controladores de texto
    TextEditingController searchBarController = TextEditingController();

    // Variables
    List<Map<String, dynamic>> filteredProducts = [];
    bool isSelectedHomeModule = true;
    bool isSelectedCarShopingModule = false; 
        dynamic carShopNew = {};

   void filteredProduct() {
    setState(() {
      filteredProducts = products.where((product) {
        final searchTerm = searchBarController.text.toLowerCase();
        final productName = product['name'].toString().toLowerCase();
        final productCat = product['cat'].toString().toLowerCase();
        final barCode = product['bar_code'].toString().toLowerCase();
        return productName.contains(searchTerm) || productCat.contains(searchTerm) || barCode.contains(searchTerm);
      }).toList();
    });
  }

void getProductsWines()async {


await getAllProducts();


}

  void addProductsToCar(index){


      Map<String, dynamic> itemsForCarShop =   {
        'id':index +1 , 
        'fecha': '06/07/2024',
        'quantity': filteredProducts[index]['quantity'],
        'product_id': index + 1 ,
        'precio': 23,

      };

          carShopNew =  carShop.firstWhere((value) {

            return  value['product_id'] == index + 1;
            
          
          },orElse: () {
            return {};
          },);

          if(carShopNew['quantity'] == 0){

            return;
          }

      if(carShopNew.isNotEmpty){

          setState(() {
            
            carShopNew['quantity'] = filteredProducts[index]['quantity'];

          });

        }else{

          carShop.add(itemsForCarShop);
        } 
        
        localStorage.setItem('carShop', jsonEncode(carShop));

        var traerCarroLocalStorage = jsonDecode(localStorage.getItem('carShop')!);

        print('Esto es el valor de traerCarroLocalStorage $traerCarroLocalStorage');

        print('Esto es el carshop en incremento $carShop');


  }

     void removeProductsToCar(index){


          List getCarLocalStorage = jsonDecode(localStorage.getItem('carShop')!);


              getCarLocalStorage.removeWhere((value){

                 return value['id'] == index + 1; 

              });


          localStorage.setItem('carShop', jsonEncode(getCarLocalStorage));
 

    
        print('Esto es el carshop en eliminando ese producto $carShop');


  }



 void increaseQuantity(int index) {
  if (filteredProducts[index]['quantity'] >= 0 && filteredProducts[index]['quantity'] < filteredProducts[index]['stock'] ) {
    
      setState(() {
        filteredProducts[index]['quantity']++;
      });

   }

      carShopNew =  carShop.firstWhere((value) {

            return  value['product_id'] == index + 1;
            
          
          },orElse: () {
            return {};
          },);

    if(carShopNew.isNotEmpty){

        carShopNew['quantity'] =  filteredProducts[index]['quantity'];

    }
   localStorage.setItem('carShop', jsonEncode(carShop));

    var getCarritoLocal = localStorage.getItem('carShop');

    print('Este es el localstorage del carrito $getCarritoLocal');

    print('Esto es el carrito $carShop');
   

  }

  void decreaseQuantity(int index) {
//       Map<String, dynamic> itemsForCarShop =   {
//         'id':index +1 , 
//         'fecha': '06/07/2024',
//         'quantity': products[index]['quantity'],
//         'product_id': index + 1 ,
//         'precio': 23,
        

//       };

        carShopNew =  carShop.firstWhere((value) {

            return  value['product_id'] == index + 1;
            
          
          },orElse: () {
            return {};
          },);




    if(filteredProducts[index]['quantity'] <= 0){
      return;
    }

    // if(carShopNew['quantity'] <= 0){

    //     return;
    // }



    setState(() {

        filteredProducts[index]['quantity']--;

         if(carShopNew.isNotEmpty){

            carShopNew['quantity'] =  filteredProducts[index]['quantity'];

        }
      
    });

    localStorage.setItem('carShop', jsonEncode(carShop));

    print('Esto es el carshop en decrease $carShop');
    
  }


  @override
  void initState() {

    getProductsWines();
    
    // localStorage.clear();
  
    var setearLocal = localStorage.getItem('carShop');
  
    print('Esto es el valor del local Storage $setearLocal');

    filteredProducts = products;
    super.initState();
  }

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
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                                 
                      children: [
                        const SizedBox(height: 70,),
                      
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(child:  Image.asset('lib/assets/logo@3x.png', width: 70,)),
                            Container(
                              width: mediaScreen *0.5,
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Bem-vindo', style: TextStyle(fontFamily: 'Neuton ExtraBold' ,color: Colors.white, fontSize: 35),),
                                  Text('Faça sua compra com o cupom', style: TextStyle(fontFamily: 'Neuton Regular', color: Colors.white),)
                                ],
                              ),
                            ),
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
                                    searchBarController.text = barCode;
                                   filteredProduct();
                                  });
                                }
                                },
                                child: Image.asset('lib/assets/QR.png')),
                            ),
                          ],
                        ),
                      ],
                  
                  ),
                ),
                
                           ) ,
               
                           body: Center(
                child: Container(
                  width: mediaScreen,
                  child: Column(
                      
                    children: [
                      const SizedBox(height: 15,),
                        Container(
                          width: mediaScreen ,
                          decoration:  BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(55) ,
                          ),
                          child:  TextField(
                              controller: searchBarController,
                              onChanged: (value) {

                                  filteredProduct();

                              },
                              style:  const TextStyle(color: Color(0XFF053452)),
                              decoration: InputDecoration(
                                hintText: "Busqueda por nome o marca...",
                                hintStyle: TextStyle(fontFamily: 'Neuton Regular', color: const Color(0XFF053452).withOpacity(0.5),),
                                suffixIcon:  Icon(Icons.search, color: Color(int.parse('0XFF053452')),), 
                                contentPadding: const EdgeInsets.all(15),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none
                                )
                              ),
                                
                  
                          ),
                        ),
                        SizedBox(height: heightScreen *0.03,),
                  Expanded(
                  child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: filteredProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Número de elementos por fila
                      mainAxisSpacing: 10.0, // Espacio vertical entre elementos
                      crossAxisSpacing: 10.0, // Espacio horizontal entre elementos
                      childAspectRatio: 0.5, // Relación de aspecto de los elementos (ajusta según necesites)
                    ),
                    itemBuilder: (context, index) {
                      print('Esto es el producto ${filteredProducts[index]['name']}');

                      return GestureDetector(
                        onTap: () {
                            showModalBottomSheet(elevation: 0,context: context, builder: (context) {                              
                                return 
                                  StatefulBuilder(
                                    builder: (BuildContext context, setStates) {
                                      return  
                                 Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                       borderRadius: BorderRadius.only(topLeft:  Radius.circular(35), topRight: Radius.circular(35)),
                                    ),
                                    width: double.infinity,
                                    height: heightScreen * 0.5,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        SizedBox(height: heightScreen * 0.02,),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                                                              
                                            width: mediaScreen * 0.3,
                                            height: 5.5,
                                            decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(15)
                                            
                                            ) ,
                                                                              
                                          ),
                                        ),
                                    
                                        Row(children: [
                                          SizedBox(height: heightScreen * 0.3,),
                                    
                                         Image.asset(products[index]['url_photo'], width: mediaScreen * 0.5,) ,
                                         Container(
                                          width: mediaScreen * 0.5,
                                           child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Text(filteredProducts[index]['name'], style: const TextStyle(fontFamily: 'Neuton Regular', fontSize: 20, color: Color(0XFF053452)),),
                                               Text(filteredProducts[index]['cat'], style: const TextStyle(fontFamily: 'Neuton Regular', fontSize: 20, color: Color(0XFF053452)),),
                                               Text('R \$${filteredProducts[index]['price']}', style: const TextStyle(fontSize: 25,fontFamily: 'AlegreyaSans Bold', color: Color(0XFF053452)),),
                                               
                                               SizedBox(height: heightScreen * 0.03 ,),
                                                Row(
                                                
                                                children: [
                                    
                                                GestureDetector(
                                                    onTap: () {
                                                      setStates(() {
                                                  
                                                        decreaseQuantity(index);
                                                  
                                                      },);
                                                                                
                                                    },
                                                child: Image.asset('lib/assets/menos@2x.png', width: 25,)),
                                                                             const SizedBox(width: 5,),
                                    
                                                                                 Padding(
                                            padding: const EdgeInsets.only(bottom: 4.3),
                                            child: Text('${filteredProducts[index]['quantity']}', style: const TextStyle( fontSize: 20 , fontFamily: 'Neuton Regular'),),
                                                                                 ),
                                            const SizedBox(width: 5,),
                                              GestureDetector(
                                                onTap: () {
                                           
                                              setStates(() {
                                                
                                                increaseQuantity(index);
                                              },);
                                           
                                                },
                                              child: Image.asset('lib/assets/mas@2x.png', width: 25,)),
                                              const SizedBox(width: 20,),
                                              GestureDetector(
                                                onTap: () {
                                                 
                                                  addProductsToCar(index);
                                            
                                                } ,
                                                child: Image.asset('lib/assets/carrito@2x.png', width: 25,)),
                                    
                                                            
                                                ],),
                                    
                                    
                                    
                                    
                                            
                                             ],
                                           ),
                                         )
                                    
                                        ],),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 20,),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Text('Qualificação:', style: TextStyle(fontFamily: 'Neuton Bold', color: Color(0XFF053452)),),
                                                          SizedBox(width: mediaScreen *0.02,),
                                                          PannableRatingBar( onChanged: (value) {
                                                          
                                                            setStates((){
                                                      
                                                            filteredProducts[index]['qualifer'] = value;
                                                            
                                                            });
                                                            print('Valor de la calificacion ${filteredProducts[index]['qualifer']} ');
                                                          } ,rate: double.parse(filteredProducts[index]['qualifer'].toString()), items: List.generate(5, (inde) =>  RatingWidget(
                                                          selectedColor: const Color.fromARGB(255, 163, 148, 17),
                                                          unSelectedColor: Colors.grey,
                                                          child: 
                                                            Image.asset('lib/assets/estrelladorada@2x.png', width: 20,)
                                                          )))
                                                        ],
                                                      ),
                                                      SizedBox(height: heightScreen * 0.01,),
                                                        Row(
                                                        children: [
                                                          Expanded(
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  const TextSpan(
                                                                    text: 'Localização do vinhedo: ',
                                                                    style: TextStyle(
                                                                      fontFamily: 'Neuton Bold',
                                                                      color: Color(0XFF053452),
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: filteredProducts[index]['localizacion'],
                                                                    style: const TextStyle(
                                                                      fontFamily: 'Neuton Regular',
                                                                      color: Color(0XFF053452),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    SizedBox(height: heightScreen * 0.01,),

                                                        Row(
                                                        children: [
                                                          Expanded(
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  const TextSpan(
                                                                    text: 'Ano de plantio: ',
                                                                    style: TextStyle(
                                                                      fontFamily: 'Neuton Bold',
                                                                      color: Color(0XFF053452),
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: filteredProducts[index]['ano_de_plantio'].toString(),
                                                                    style: const TextStyle(
                                                                      fontFamily: 'Neuton Regular',
                                                                      color: Color(0XFF053452),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: heightScreen * 0.01,),

                                                       Row(
                                                        children: [
                                                          Expanded(
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  const TextSpan(
                                                                    text: 'Tipo de solo: ',
                                                                    style: TextStyle(
                                                                      fontFamily: 'Neuton Bold',
                                                                      color: Color(0XFF053452),
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: filteredProducts[index]['tipo_de_solo'],
                                                                    style: const TextStyle(
                                                                      fontFamily: 'Neuton Regular',
                                                                      color: Color(0XFF053452),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: heightScreen * 0.01,),

                                                        Row(
                                                        children: [
                                                          Expanded(
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  const TextSpan(
                                                                    text: 'Produção: ',
                                                                    style: TextStyle(
                                                                      fontFamily: 'Neuton Bold',
                                                                      color: Color(0XFF053452),
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: filteredProducts[index]['localizacion'],
                                                                    style: const TextStyle(
                                                                      fontFamily: 'Neuton Regular',
                                                                      color: Color(0XFF053452),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                        SizedBox(height: heightScreen * 0.01,),

                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  const TextSpan(
                                                                    text: 'Altura: ',
                                                                    style: TextStyle(
                                                                      fontFamily: 'Neuton Bold',
                                                                      color: Color(0XFF053452),
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: filteredProducts[index]['altura'],
                                                                    style: const TextStyle(
                                                                      fontFamily: 'Neuton Regular',
                                                                      color: Color(0XFF053452),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                    
                                                      SizedBox(height: heightScreen * 0.01,),
                                    
                                                    ],
                                                  ),
                                                ),
                                      ],
                                    ),
                                  ),
                                );

                                },
                              );
                             },
                           );
                        } ,
                        child: Container(
                          height: heightScreen * 0.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7
                                )                      
                            ]
                          ),
                          margin: const EdgeInsets.all(5.0),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SingleChildScrollView(
                        
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    Align(
                                          alignment: Alignment.topCenter, // Alinea la imagen al centro superior
                                          child: Image.asset(
                                            filteredProducts[index]['url_photo'],
                                            width: 100,
                                            height: 170,
                                          ),
                                        ),                                Text(
                                    products[index]['name'].toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 15,fontFamily: 'Neuton Regular'),
                                  ),
                                  Text(filteredProducts[index]['cat'], style: const TextStyle( fontSize: 15,fontFamily: 'Neuton Regular', color: Color(0XFFB47C2D)),),
                                  SizedBox(height: heightScreen * 0.01,),
                                  Text('R \$${filteredProducts[index]['price']}', style: const TextStyle(fontSize: 20,fontFamily: 'Neuton ExtraBold', color: Color(0XFF053452)),),
                                  SizedBox(height: heightScreen*0.01,),
                                  Row(
                                    children: [
                                      
                                      GestureDetector(
                                        onTap: () {
                                          
                                          decreaseQuantity(index);
                              
                                        },
                                        child: Image.asset('lib/assets/menos@2x.png', width: 25,)),
                                     const SizedBox(width: 5,),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 4.3),
                                        child: Text('${filteredProducts[index]['quantity']}', style: const TextStyle( fontSize: 20 , fontFamily: 'Neuton Regular'),),
                                      ),
                                     const SizedBox(width: 5,),
                                     GestureDetector(
                                      onTap: () {
                                        
                                        
                                        increaseQuantity(index);
                                      },
                                      child: Image.asset('lib/assets/mas@2x.png', width: 25,)),
                                     const SizedBox(width: 20,),
                                     GestureDetector(
                                     onTap: () {
                                         
                                        addProductsToCar(index);

                                     },
                                     child: Image.asset('lib/assets/carrito@2x.png', width: 25,)),


                                     
                                                    
                                  ],)
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),


                  ],
                 ),
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

                            Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route)=> false, arguments: 0);
                            // Navigator.pushNamed(context,  '/home');

                            }, child: Image.asset('lib/assets/home@2x.png', width: 50, color: isSelectedHomeModule ? const Color(0xFF053452): Colors.grey,),),
                        ),
                      ),
                      Container(
                    
                        child: GestureDetector(
                          onTap: () {
                               setState(() {
                                  isSelectedHomeModule = false;
                                  isSelectedCarShopingModule = true;
                                });
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/car-shop',
                            (Route<dynamic> route) => false,
                            arguments: 0,
                          );
                          //  Navigator.pushNamed(context,  '/car-shop');

                          },

                          child: Image.asset('lib/assets/carrito@2x.png', width: 50, color: isSelectedCarShopingModule ? const Color(0xFF053452) : Colors.grey,),
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












