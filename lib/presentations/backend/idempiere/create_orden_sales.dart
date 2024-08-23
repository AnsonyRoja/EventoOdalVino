import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';



Future<bool> checkInternetConnectivity() async {
  dynamic map = {"URL": 'https://parbras.dyndns.info:53659/ADInterface/services/rest/model_adservice/query_data'};
  try {
    // Desactivar la verificación del certificado SSL
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    // Realizar la solicitud HTTP con el cliente personalizado
    final response = await client.headUrl(Uri.parse('${map['URL']}'));
    final httpResponse = await response.close();

    print('Esto es http ${httpResponse.statusCode}');
    // Verificar si la respuesta tiene un código de estado exitoso (2xx)
    if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
      // Se recibió una respuesta exitosa, lo que significa que hay conexión a internet
      return true;
    } else {
      // No se recibió una respuesta exitosa, lo que significa que no hay conexión a internet
      return false;
    }
  } catch (e) {
    // Si ocurre algún error durante la solicitud, asumimos que no hay conexión a internet
    print('Error al verificar la conexión a internet: $e');
    return false;
  }
}

// Esta funcion nos ayudara a crear una nueva orden

createOrdenSalesIdempiere(orderSalesList) async {
  dynamic resOrdenSales = orderSalesList;

  if (orderSalesList is Future) {
    resOrdenSales = await orderSalesList;
  }


  dynamic isConnection = await checkInternetConnectivity();

  if (!isConnection) {
    return false;
  }


 

  HttpClient httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) {
      return true;
    };

  try {
    

    

    
    final uri = Uri.parse('https://parbras.dyndns.info:53659/ADInterface/services/rest/model_adservice/query_data');

    final request = await httpClient.postUrl(uri);

    final info = await getApplicationSupportDirectory();
    print("esta es la ruta ${info.path}");

    final String filePathEnv = '${info.path}/.env';
    final File archivo = File(filePathEnv);
    String contenidoActual = await archivo.readAsString();
    print('Contenido actual del archivo:\n$contenidoActual');

    // Convierte el contenido JSON a un mapa
    dynamic requestBody = {};
    Map<String, dynamic> jsonData = jsonDecode(contenidoActual);

    var role = jsonData["RoleID"];
    var orgId = jsonData["OrgID"];
    var clientId = jsonData["ClientID"];
    var wareHouseId = jsonData["WarehouseID"];
    var language = jsonData["Language"];
    print("Esto es orderSales List nuevo $resOrdenSales");

    print('Esto es el payment Rule ${resOrdenSales['order']}');

        requestBody = {
          "CompositeRequest": {
            "ADLoginRequest": {
              "user": 'aRojas',
              "pass": 'aRojas',
              "lang": jsonData["Language"],
              "ClientID": jsonData["ClientID"],
              "RoleID": jsonData["RoleID"],
              "OrgID": jsonData["OrgID"],
              "WarehouseID": jsonData["WarehouseID"],
              "stage": "9",
            },
            "serviceType": "UCCompositeOrder",
            "operations": {
              "operation": [
                {
                  "@preCommit": "false",
                  "@postCommit": "false",
                  "TargetPort": "createData",
                  "ModelCRUD": {
                    "serviceType": "UCCreateOrder",
                    "TableName": "C_Order",
                    "RecordID": "0",
                    "Action": "CreateUpdate",
                    "DataRow": {
                      "field": [
                        {
                          "@column": "AD_Client_ID",
                          "val": resOrdenSales['order']['ad_client_id']
                        },
                        {
                          "@column": "AD_Org_ID",
                          "val": resOrdenSales['order']['ad_org_id']
                        },
                        {
                          "@column": "C_BPartner_ID",
                          "val": resOrdenSales['order']['c_bpartner_id'],
                        },
                        {
                          "@column": "C_BPartner_Location_ID",
                          "val": resOrdenSales['order']['c_bpartner_location_id'],
                        },
                        {
                          "@column": "C_Currency_ID",
                          "val": resOrdenSales['order']['c_currency_id'] ,
                        },
                        {
                          "@column": "Description",
                          "val": resOrdenSales['order']['descripcion'],
                        },
                        {
                          "@column": "C_ConversionType_ID",
                          "val": "1000009"
                        },
                        {
                          "@column": "C_DocTypeTarget_ID",
                          "val": resOrdenSales['order']['c_doctypetarget_id']
                        },
                        {
                          "@column": "C_PaymentTerm_ID",
                          "val": resOrdenSales['order']['c_payment_term_id']
                        },
                        {
                          "@column": "DateOrdered",
                          "val": resOrdenSales['order']['date_ordered']
                        },
                        {"@column": "IsTransferred", "val": 'Y'},
                        {
                          "@column": "M_PriceList_ID",
                          "val": resOrdenSales['client'][0]['list_price']
                        },
                        {
                          "@column": "M_Warehouse_ID",
                          "val": resOrdenSales['order']['m_warehouse_id']
                        },
                        {"@column": "PaymentRule", "val":  resOrdenSales['order']['payment_rule'].toString() != '{@nil=true}' && resOrdenSales['order']['payment_rule'] != null ? resOrdenSales['order']['payment_rule'] : 'P'},
                        {
                          "@column": "SalesRep_ID",
                          "val": resOrdenSales['order']['usuario_id']
                        },
                        {
                          "@column": "C_SalesRegion_ID",
                          "val": resOrdenSales['order']['sales_region_id']
                        },
                       
                        {
                          "@column": "DeliveryRule",
                          "val": resOrdenSales['order']['delivery_rule'] ?? 'A'
                        },
                        {
                          "@column": "DeliveryViaRule",
                          "val": resOrdenSales['order']['delivery_via_rule'] ?? 'D'
                        },
                        {
                          "@column": "InvoiceRule",
                          "val": resOrdenSales['order']['invoice_rule'] ?? 'I'
                        },
            
                        {
                          "@column": "M_DiscountSchema_ID",
                          "val": resOrdenSales['order']['m_discount_schema_id'] 
                        },
                      
                        
                        // {
                        //   "@column": "AD_User_ID",
                        //   "val": resOrdenSales['order']['usuario_id']
                        // },
                        // {
                        //   "@column": "Bill_User_ID",
                        //   "val": resOrdenSales['order']['usuario_id']
                        // },

                        {"@column": "LVE_PayAgreement_ID", "val": '1000001'},
                        {"@column": "IsSOTrx", "val": 'Y'}
                      ]
                    }
                  }
                },
              ]
            }
          }
        };


   
    // Crear las líneas de la orden
    final lines =
        createLines(resOrdenSales['products'], resOrdenSales['order'], resOrdenSales['order']['cargos'] ?? []);

    // Agregar las líneas de la orden al JSON de la orden
    for (var line in lines) {
      requestBody['CompositeRequest']['operations']['operation'].add(line);
    }

    dynamic doAction = {
      "@preCommit": "false",
      "@postCommit": "false",
      "TargetPort": "setDocAction",
      "ModelSetDocAction": {
        "serviceType": "completeOrder",
        "tableName": "C_Order",
        "recordIDVariable": "@C_Order.C_Order_ID",
        "docAction": "PR",
      }
    };

    requestBody['CompositeRequest']['operations']['operation'].add(doAction);

    // Configurar el cuerpo de la solicitud en formato JSON

    final jsonBody = jsonEncode(requestBody);

    request.headers.set('Content-Type', 'application/json; charset=utf-8');
    request.headers.set('Accept', 'application/json');

    request.write(jsonBody);

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    final parsedJson = jsonDecode(responseBody);

    print("esta es la respuesta orderSales $parsedJson on");

    // dynamic isErrorTwo = parsedJson['CompositeResponses']['CompositeResponse']['StandardResponse']['@IsError'] ?? 0;
    //   if(isErrorTwo == 0){
    //     print('no hay errores');
    //   }else if(isErrorTwo){
    //     return false;
    //   }

    

    if (parsedJson['message'] != null &&
        parsedJson['message'].toString().contains('Service Unavailable')) {
      return false;
    }

   
 dynamic searchKey(dynamic json, String key) {
        if (json is Map) {
          if (json.containsKey(key)) {
            return json[key];
          }
          for (var value in json.values) {
            var result = searchKey(value, key);
            if (result != null) return result;
          }
        } else if (json is List) {
          for (var element in json) {
            var result = searchKey(element, key);
            if (result != null) return result;
          }
        }
        return null;
      }

   
        dynamic documentNo = searchKey(parsedJson['CompositeResponses']['CompositeResponse']
        ['StandardResponse'][0]['outputFields']['outputField'][1], '@value');
      dynamic docStatus = searchKey(parsedJson, '@Text');
      dynamic haveError = searchKey(parsedJson, '@IsError');

      print('Esto es el error $haveError');

      if(haveError == true){
        return false;
      }

        print(docStatus); // Imprimirá: En Proceso
        print('El valor del Doc Status $docStatus');

    dynamic cOrderId = searchKey(parsedJson['CompositeResponses']['CompositeResponse']
        ['StandardResponse'][0]['outputFields']['outputField'][0], '@value');

  


  

    return parsedJson;
  } catch (e) {
    return 'este es el error e $e';
  }
}

createLines(lines, order, cargos) {
  List linea = [];

  print('Estas son las lineas $lines');

  dynamic cargosJsonDecode = jsonDecode(cargos);
  print('Estos son los cargosJsonDecode $cargosJsonDecode');
try {
  

  if(cargosJsonDecode.isNotEmpty){

  
  cargosJsonDecode.forEach((line) => {

    print('Linea del cargo $line'),

    print('esta es ad client id ${order['ad_client_id']} y este es el org id ${order['ad_org_id']}'),

        linea.add({
          "@preCommit": "false",
          "@postCommit": "false",
          "TargetPort": "createData",
          "ModelCRUD": {
            "serviceType": "UCCreateOrderLine",
            "TableName": "C_OrderLine",
            "recordID": "0",
            "Action": "Create",
            "DataRow": {
              "field": [
                {"@column": "AD_Client_ID", "val": line['ad_client_id'] ?? order['ad_client_id']},
                {"@column": "AD_Org_ID", "val": line['ad_org_id'] ?? order['ad_org_id']},
                {"@column": "M_Warehouse_ID", "val":  line['m_warehouse_id'] ?? order['m_warehouse_id']},

                {"@column": "C_Order_ID", "val": "@C_Order.C_Order_ID"},
                {
                  "@column": "PriceEntered",
                  "val": double.parse(line['total_importe'].toString().replaceAll(',', '.'))
                },
                {
                  "@column": "PriceActual",
                  "val": double.parse(line['total_importe'].toString().replaceAll(',', '.'))
                },
                {"@column": "C_Charge_ID", "val": line['c_charge_id']},
                {
                  "@column": "QtyOrdered",
                  "val":  line['quantity']
                },
                {
                  "@column": "QtyEntered",
                  "val":  line['quantity']
                },
                {
                  "@column": "IsDocumentDiscount",
                  "val":  line['is_document_discount'].toString()
                },
                 {
                  "@column": "Discount",
                  "val":  line['price']
                },
                
                // {"@column": "SalesRep_ID", "val": order['salesrep_id']}
              ]
            }
          }
        })
      

  });

  lines.forEach((line) => {

        print("line ${line}"),

       if(double.parse(line['price_discount'].toString()) > 0) {

            print('Entre en el primer if'),
            print('Esto es el warehouse ${line['m_warehouse_id']}'),

        linea.add({
          "@preCommit": "false",
          "@postCommit": "false",
          "TargetPort": "createData",
          "ModelCRUD": {
            "serviceType": "UCCreateOrderLine",
            "TableName": "C_OrderLine",
            "recordID": "0",
            "Action": "Create",
            "DataRow": {
              "field": [
                {"@column": "AD_Client_ID", "val": line['ad_client_id'] ?? order['ad_client_id']},
                {"@column": "AD_Org_ID", "val": line['ad_org_id'] ?? order['ad_org_id']},
                {"@column": "M_Warehouse_ID", "val": line['m_warehouse_id'] == 0 ? order['m_warehouse_id'] : line['m_warehouse_id'] },
                {"@column": "C_Order_ID", "val": "@C_Order.C_Order_ID"},
                {
                  "@column": "PriceEntered",
                  "val": line['price_discount'] ?? line['price']
                },
                {
                  "@column": "PriceActual",
                  "val":  line['price_discount'] ?? line['price']
                },
                {"@column": "M_Product_ID", "val": line['m_product_id']},
                {
                  "@column": "QtyOrdered",
                  "val": line['qty_entered'] ?? line['quantity']
                },
                 {
                  "@column": "PriceList",
                  "val": line['price'] == 0 || line['price'] == null ?  line['price_actual'] : line['price']
                },
                   {
                  "@column": "Discount",
                  "val":  line['discount_percent']
                },
                {
                  "@column": "QtyEntered",
                  "val": line['qty_entered'] ?? line['quantity']
                },
                {
                  "@column": "IsDocumentDiscount",
                  "val":  line['is_document_discount']
                },
                {
                  "@column": "C_UOM_ID",
                  "val":  line['um_id']
                },
                // {"@column": "SalesRep_ID", "val": order['salesrep_id']}
              ]
            }
          }
        })

       } else{

                    print('Entre en el Segundo if'),

        linea.add({
          "@preCommit": "false",
          "@postCommit": "false",
          "TargetPort": "createData",
          "ModelCRUD": {
            "serviceType": "UCCreateOrderLine",
            "TableName": "C_OrderLine",
            "recordID": "0",
            "Action": "Create",
            "DataRow": {
              "field": [
                {"@column": "AD_Client_ID", "val": line['ad_client_id'] ?? order['ad_client_id']},
                {"@column": "AD_Org_ID", "val": line['ad_org_id'] ?? order['ad_org_id']},
                {"@column": "M_Warehouse_ID", "val": line['m_warehouse_id'] == 0 ? order['m_warehouse_id'] : line['m_warehouse_id'] },
                {"@column": "C_Order_ID", "val": "@C_Order.C_Order_ID"},
                {
                  "@column": "PriceEntered",
                  "val": line['price_actual'] ?? line['price']
                },
                {
                  "@column": "PriceActual",
                  "val": line['price_actual'] ?? line['price']
                },
                {"@column": "M_Product_ID", "val": line['m_product_id']},
                {
                  "@column": "QtyOrdered",
                  "val": line['qty_entered'] ?? line['quantity']
                },
                {
                  "@column": "PriceList",
                  "val":   line['price'] == 0 || line['price'] == null ?  line['price_actual'] : line['price']
                },
                {
                  "@column": "QtyEntered",
                  "val": line['qty_entered'] ?? line['quantity']
                },
                  {
                  "@column": "IsDocumentDiscount",
                  "val":  line['is_document_discount']
                },
                    {
                  "@column": "C_UOM_ID",
                  "val":  line['um_id']
                },
                // {"@column": "SalesRep_ID", "val": order['salesrep_id']}
              ]
            }
          }
        })
       }
        
      });
  }else{

      print('total de lineas $lines');
              print('Entre en el Tercer if');


      lines.forEach((line) => {
        print("line ${line}"), 

        if(line['m_warehouse_id'] > 0){

               if(double.parse(line['price_discount'].toString()) > 0) {
                print('Pase por aqui en el tercer if'),

                            linea.add({
                  "@preCommit": "false",
                  "@postCommit": "false",
                  "TargetPort": "createData",
                  "ModelCRUD": {
                    "serviceType": "UCCreateOrderLine",
                    "TableName": "C_OrderLine",
                    "recordID": "0",
                    "Action": "Create",
                    "DataRow": {
                      "field": [
                        {"@column": "AD_Client_ID", "val": line['ad_client_id']},
                        {"@column": "AD_Org_ID", "val": line['ad_org_id']},
                        {"@column": "M_Warehouse_ID", "val": line['m_warehouse_id']},
                        {"@column": "C_Order_ID", "val": "@C_Order.C_Order_ID"},
                        
                        {
                          "@column": "PriceEntered",
                          "val": line['price_discount'] ?? line['price']
                        },
                        
                        {
                          "@column": "PriceActual",
                          "val": line['price_discount'] ?? line['price']
                        },
                        {"@column": "M_Product_ID", "val": line['m_product_id']},
                        {
                          "@column": "QtyOrdered",
                          "val": line['qty_entered'] ?? line['quantity']
                        },
                         {
                          "@column": "Discount",
                          "val": line['discount_percent'] 
                        },
                         {
                          "@column": "PriceList",
                          "val":  line['price'] == 0 || line['price'] == null ?  line['price_actual'] : line['price']
                        },
                        {
                          "@column": "QtyEntered",
                          "val": line['qty_entered'] ?? line['quantity']
                        },
                          {
                          "@column": "IsDocumentDiscount",
                          "val":  line['is_document_discount']
                        },
                            {
                          "@column": "C_UOM_ID",
                          "val":  line['um_id']
                        },
                        // {"@column": "SalesRep_ID", "val": order['salesrep_id']}
                      ]
                    }
                  }
                })

               }else{
                            print('Entre en el cuarto if'),

                linea.add({
                  "@preCommit": "false",
                  "@postCommit": "false",
                  "TargetPort": "createData",
                  "ModelCRUD": {
                    "serviceType": "UCCreateOrderLine",
                    "TableName": "C_OrderLine",
                    "recordID": "0",
                    "Action": "Create",
                    "DataRow": {
                      "field": [
                        {"@column": "AD_Client_ID", "val": line['ad_client_id']},
                        {"@column": "AD_Org_ID", "val": line['ad_org_id']},
                        {"@column": "M_Warehouse_ID", "val": line['m_warehouse_id']},
                        {"@column": "C_Order_ID", "val": "@C_Order.C_Order_ID"},
                        
                        {
                          "@column": "PriceEntered",
                          "val": line['price_actual'] ?? line['price']
                        },
                        
                        {
                          "@column": "PriceActual",
                          "val": line['price_actual'] ?? line['price']
                        },
                        {"@column": "M_Product_ID", "val": line['m_product_id']},
                        {
                          "@column": "QtyOrdered",
                          "val": line['qty_entered'] ?? line['quantity']
                        },
                         {
                          "@column": "PriceList",
                          "val":  line['price'] == 0 || line['price'] == null ?  line['price_actual'] : line['price']
                        },
                        {
                          "@column": "QtyEntered",
                          "val": line['qty_entered'] ?? line['quantity']
                        },
                          {
                          "@column": "IsDocumentDiscount",
                          "val":  line['is_document_discount']
                        },
                         {
                          "@column": "C_UOM_ID",
                          "val":  line['um_id']
                        },
                        // {"@column": "SalesRep_ID", "val": order['salesrep_id']}
                      ]
                    }
                  }
                })

               }
    } else{


        print('Entre en el quinto if'),
          if(double.parse(line['price_discount'].toString()) > 0) {

                    linea.add({
              "@preCommit": "false",
              "@postCommit": "false",
              "TargetPort": "createData",
              "ModelCRUD": {
                "serviceType": "UCCreateOrderLine",
                "TableName": "C_OrderLine",
                "recordID": "0",
                "Action": "Create",
                "DataRow": {
                  "field": [
                    {"@column": "AD_Client_ID", "val": order['ad_client_id']},
                    {"@column": "AD_Org_ID", "val": order['ad_org_id']},
                    {"@column": "M_Warehouse_ID", "val": order['m_warehouse_id']},
                    {"@column": "C_Order_ID", "val": "@C_Order.C_Order_ID"},
                    
                    {
                      "@column": "PriceEntered",
                      "val": line['price_discount'] ?? line['price']
                    },
                    
                    {
                      "@column": "PriceActual",
                      "val": line['price_discount'] ?? line['price']
                    },
                    {"@column": "M_Product_ID", "val": line['m_product_id']},
                    {
                      "@column": "QtyOrdered",
                      "val": line['qty_entered'] ?? line['quantity']
                    },
                    {
                      "@column": "PriceList",
                      "val":  line['price'] == 0 ?  line['price_actual'] : line['price']
                    },
                     {
                      "@column": "Discount",
                      "val": line['discount_percent'] 
                    },
                    {
                      "@column": "QtyEntered",
                      "val": line['qty_entered'] ?? line['quantity']
                    },
                    {
                      "@column": "IsDocumentDiscount",
                      "val":  line['is_document_discount']
                    },
                        {
                      "@column": "C_UOM_ID",
                      "val":  line['um_id']
                    },
                    // {"@column": "SalesRep_ID", "val": order['salesrep_id']}
                  ]
                }
              }
            })

          
          }else{

                        print('Entre en el sexsto if'),


                linea.add({
              "@preCommit": "false",
              "@postCommit": "false",
              "TargetPort": "createData",
              "ModelCRUD": {
                "serviceType": "UCCreateOrderLine",
                "TableName": "C_OrderLine",
                "recordID": "0",
                "Action": "Create",
                "DataRow": {
                  "field": [
                    {"@column": "AD_Client_ID", "val": order['ad_client_id']},
                    {"@column": "AD_Org_ID", "val": order['ad_org_id']},
                    {"@column": "M_Warehouse_ID", "val": order['m_warehouse_id']},
                    {"@column": "C_Order_ID", "val": "@C_Order.C_Order_ID"},
                    
                    {
                      "@column": "PriceEntered",
                      "val": line['price_actual'] ?? line['price']
                    },
                    
                    {
                      "@column": "PriceActual",
                      "val": line['price_actual'] ?? line['price']
                    },
                    {"@column": "M_Product_ID", "val": line['m_product_id']},
                    {
                      "@column": "QtyOrdered",
                      "val": line['qty_entered'] ?? line['quantity']
                    },
                    {
                      "@column": "PriceList",
                      "val":  line['price'] == 0 ?  line['price_actual'] : line['price']
                    }, 
                    {
                      "@column": "QtyEntered",
                      "val": line['qty_entered'] ?? line['quantity']
                    },
                      {
                      "@column": "IsDocumentDiscount",
                      "val":  line['is_document_discount']
                    },
                     {
                      "@column": "C_UOM_ID",
                      "val":  line['um_id']
                    },
                    // {"@column": "SalesRep_ID", "val": order['salesrep_id']}
                  ]
                }
              }
            })

          }



    }
    
     });
    
  }
} catch (e) {

    print('Este es el error $e');
}
  print("estas son las lineas $linea");

  return linea;
}
