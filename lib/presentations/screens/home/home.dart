
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:odalvinoeventoapp/presentations/backend/peticiones_http/get_products_http.dart';
import 'package:odalvinoeventoapp/presentations/screens/home/design/animation_car.dart';
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
    List<dynamic> filteredProducts = [];
    bool isSelectedHomeModule = true;
    bool isSelectedCarShopingModule = false; 
    dynamic carShopNew = {};
    List listProducts = [];
    Future? getProductsFuture;

   void filteredProduct() {
    setState(() {
      filteredProducts = listProducts.where((product) {
        final searchTerm = searchBarController.text.toLowerCase();
        final productName = product['product_name'].toString().toLowerCase();
        final productCat = product['product_brand'].toString().toLowerCase();
        final barCode = product['upc'].toString().toLowerCase();
        return productName.contains(searchTerm) || productCat.contains(searchTerm) || barCode.contains(searchTerm);
      }).toList();
    });
  }

Future getProductsWines() async {

  

   getProductsFuture = getAllProducts();
     

  return getProductsFuture;


}

void addProductsToCar(int index) {
  // Crear el mapa del producto a agregar al carrito
  Map<String, dynamic> itemsForCarShop = {
    'id': index + 1,
    'fecha': DateFormat('dd/MM/yyyy').format(DateTime.now()),
    'product_name': filteredProducts[index]['product_name'],
    'product_brand': filteredProducts[index]['product_brand'],
    'image_url': filteredProducts[index]['image_url'],
    'stock': filteredProducts[index]['qty_on_hand'],
    'quantity': filteredProducts[index]['quantity'], // Cantidad a agregar
    'product_id': filteredProducts[index]['m_product_id'],
    'precio': filteredProducts[index]['price_list'],
  };

  // Buscar si el producto ya existe en el carrito
  var existingProduct = carShop.firstWhere(
    (value) => value['product_id'] == itemsForCarShop['product_id'],
    orElse: () => {},
  );

  // Si el producto ya existe en el carrito
  if (existingProduct.isNotEmpty) {
    setState(() {
      // Incrementar la cantidad del producto existente
      existingProduct['quantity'] += itemsForCarShop['quantity'];
    });
  } else {
    // Si el producto no existe, añadirlo al carrito
    setState(() {
      carShop.add(itemsForCarShop);
    });
  }

  // Guardar el carrito actualizado en el almacenamiento local
  localStorage.setItem('carShop', jsonEncode(carShop));

  // Obtener el carrito del almacenamiento local (opcional para depuración)
  var traerCarroLocalStorage = jsonDecode(localStorage.getItem('carShop')!);

  // Imprimir resultados para depuración
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

  print('Este es el valor de index $index');
    print('Este es el valor del producto ${filteredProducts[index]}');

    int qty = int.parse(filteredProducts[index]['quantity'].toString());
    double stock = double.parse(filteredProducts[index]['qty_on_hand'].toString() == '{@nil: true}'?  "0" : filteredProducts[index]['qty_on_hand'].toString());

  if (qty >= 0 && qty < stock) {
    
      setState(() {
       filteredProducts[index]['quantity']++;
        
      });

    

   }else{

      showDialog(context: context, builder: (context) {

            return const AlertDialog(
                      title: Text('Message', style:  TextStyle(fontFamily: 'Neuton Regular',),), 
                      content:  Text('Produto não disponível, estoque insuficiente', style: TextStyle(fontFamily: 'Neuton Regular'),),

            );

      }, );

   }

      carShopNew =  carShop.firstWhere((value) {

            return  value['m_product_id'] == index + 1;
            
          
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
    // products.clear();
    // localStorage.clear();
  // localStorage.setItem('carShop', '');

    var setearLocal = localStorage.getItem('carShop');
  
    print('Esto es el valor del local Storage $setearLocal');

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
                            Image.asset('lib/assets/logo@3x.png', width: 70,),
                            SizedBox(
                              width: mediaScreen *0.5,
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Bem-vindo', style: TextStyle(fontFamily: 'Neuton ExtraBold' ,color: Colors.white, fontSize: 35),),
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
                child: SizedBox(
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

                FutureBuilder(future: getProductsFuture , builder: (context, snapshot) {

                               if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }

                                // Si el Future termina con un error, muestra un mensaje de error
                                if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                }

                                // Si el Future devuelve datos, pero la lista está vacía, muestra un mensaje
                                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const Center(child: Text('No products found'));
                                }

                                  //  filteredProducts = snapshot.data!;
                                 if (listProducts.isEmpty) {
                                    // Solo inicializar listProducts y filteredProducts si aún están vacíos
                                    listProducts = snapshot.data!;
                                    filteredProducts = List.from(listProducts);
                                  }

                                  
                                  return Expanded(
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
                                        print('Esto es el producto ${filteredProducts[index]['product_name']}');

                                        print('Filtered Products ${filteredProducts[index]}');


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
                                                      
                                                            Image.asset(filteredProducts[index]['image_url'].toString() == "{@nil: true}" ? "lib/assets/vino1.jpg": filteredProducts[index]['image_url'].toString() , width: mediaScreen * 0.5,) ,
                                                            SizedBox(
                                                            width: mediaScreen * 0.5,
                                                              child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(filteredProducts[index]['product_name'].toString(), style: const TextStyle(fontFamily: 'Neuton Regular', fontSize: 20, color: Color(0XFF053452)),),
                                                                  Text(filteredProducts[index]['product_brand'].toString(), style: const TextStyle(fontFamily: 'Neuton Regular', fontSize: 20, color: Color(0XFF053452)),),
                                                                  Text('\$${filteredProducts[index]['price_list']}', style: const TextStyle(fontSize: 25,fontFamily: 'AlegreyaSans Bold', color: Color(0XFF053452)),),
                                                                  
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
                                                                        
                                                                              // filteredProducts[index]['qualifer'] = value;
                                                                              
                                                                              });
                                                                              // print('Valor de la calificacion ${filteredProducts[index]['qualifer']} ');
                                                                            } ,rate: 5.0, items: List.generate(5, (inde) =>  RatingWidget(
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
                                                                                text: const TextSpan(
                                                                                  children: [
                                                                                    // TextSpan(
                                                                                    //   text: 'Localização do vinhedo: ',
                                                                                    //   style: TextStyle(
                                                                                    //     fontFamily: 'Neuton Bold',
                                                                                    //     color: Color(0XFF053452),
                                                                                    //   ),
                                                                                    // ),
                                                                                    // TextSpan(
                                                                                    //   text: filteredProducts[index]['localizacion'],
                                                                                    //   style: const TextStyle(
                                                                                    //     fontFamily: 'Neuton Regular',
                                                                                    //     color: Color(0XFF053452),
                                                                                    //   ),
                                                                                    // ),
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
                                                                                    // const TextSpan(
                                                                                    //   text: 'Ano de plantio: ',
                                                                                    //   style: TextStyle(
                                                                                    //     fontFamily: 'Neuton Bold',
                                                                                    //     color: Color(0XFF053452),
                                                                                    //   ),
                                                                                    // ),
                                                                                    const TextSpan(
                                                                                      text: 'Descripcion: ',
                                                                                      style: TextStyle(
                                                                                        fontFamily: 'Neuton Bold',
                                                                                        color: Color(0XFF053452),
                                                                                      ),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: filteredProducts[index]['description'].toString(),
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
                                                                                text: const TextSpan(
                                                                                  children: [
                                                                                    // const TextSpan(
                                                                                    //   text: 'Tipo de solo: ',
                                                                                    //   style: TextStyle(
                                                                                    //     fontFamily: 'Neuton Bold',
                                                                                    //     color: Color(0XFF053452),
                                                                                    //   ),
                                                                                    // ),
                                                                                    // TextSpan(
                                                                                    //   text: filteredProducts[index]['tipo_de_solo'],
                                                                                    //   style: const TextStyle(
                                                                                    //     fontFamily: 'Neuton Regular',
                                                                                    //     color: Color(0XFF053452),
                                                                                    //   ),
                                                                                    // ),
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
                                                                                text: const TextSpan(
                                                                                  children: [
                                                                                    // const TextSpan(
                                                                                    //   text: 'Produção: ',
                                                                                    //   style: TextStyle(
                                                                                    //     fontFamily: 'Neuton Bold',
                                                                                    //     color: Color(0XFF053452),
                                                                                    //   ),
                                                                                    // ),
                                                                                    // TextSpan(
                                                                                    //   text: filteredProducts[index]['localizacion'],
                                                                                    //   style: const TextStyle(
                                                                                    //     fontFamily: 'Neuton Regular',
                                                                                    //     color: Color(0XFF053452),
                                                                                    //   ),
                                                                                    // ),
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
                                                                                text: const TextSpan(
                                                                                  children: [
                                                                                    // const TextSpan(
                                                                                    //   text: 'Altura: ',
                                                                                    //   style: TextStyle(
                                                                                    //     fontFamily: 'Neuton Bold',
                                                                                    //     color: Color(0XFF053452),
                                                                                    //   ),
                                                                                    // ),
                                                                                    // TextSpan(
                                                                                    //   text: filteredProducts[index]['altura'],
                                                                                    //   style: const TextStyle(
                                                                                    //     fontFamily: 'Neuton Regular',
                                                                                    //     color: Color(0XFF053452),
                                                                                    //   ),
                                                                                    // ),
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
                                                              filteredProducts[index]['image_url'].toString() == "{@nil: true}" ? 'lib/assets/vino1.jpg' : filteredProducts[index]['image_url'].toString() ,
                                                              width: 100,
                                                              height: 170,
                                                            ),
                                                          ), 
                                                                                         Text(
                                                      filteredProducts[index]['product_name'].toString(),
                                                      textAlign: TextAlign.center,
                                                      style: const TextStyle(fontSize: 15,fontFamily: 'Neuton Regular'),
                                                    ),
                                                    Text(filteredProducts[index]['product_brand'], style: const TextStyle( fontSize: 15,fontFamily: 'Neuton Regular', color: Color(0XFFB47C2D)),),
                                                    SizedBox(height: heightScreen * 0.01,),
                                                    Text(' \$${filteredProducts[index]['price_list']}', style: const TextStyle(fontSize: 20,fontFamily: 'Neuton ExtraBold', color: Color(0XFF053452)),),
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
                                  );




                },),


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

                          child: AnimatedShoppingCart( isSelectedCarShopingModule: isSelectedCarShopingModule , ) ,
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












