
  import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';




  class HomeCards extends StatelessWidget {
    final dynamic  filteredProducts;
    final int index;
    final Function decreaseQuantity;
    final Function increaseQuantity; 
    final Function addProductsToCar;
    const HomeCards({super.key, required this.filteredProducts, required this.index, required this.addProductsToCar ,required this.increaseQuantity ,required this.decreaseQuantity});

    
    @override
    Widget build(BuildContext context) {

    final heightScreen = MediaQuery.of(context).size.height * 0.9;
    final mediaScreen = MediaQuery.of(context).size.width * 0.9;


      return  GestureDetector(
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
    }
  }












