import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';



Future<bool> checkInternetConnectivity() async {
  dynamic map = {"URL": 'https://parbras.dyndns.info:53659/ADInterface/services/rest/model_adservice/query_data'};
  try {
    // Desactivar la verificación del certificado SSL
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    // Realizar la solicitud HTTP con el cliente personalizado
    final response = await client.headUrl(Uri.parse('https://parbras.dyndns.info:53659/ADInterface/services/rest/model_adservice/query_data'));
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


  // dynamic isConnection = await checkInternetConnectivity();

  // if (!isConnection) {
  //   return false;
  // }


 

  HttpClient httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) {
      return true;
    };

  try {
    

    

    
    final uri = Uri.parse('https://parbras.dyndns.info:53659/ADInterface/services/rest/composite_service/composite_operation');

    final request = await httpClient.postUrl(uri);


    Map requestBody = {};

    print("Esto es orderSales List nuevo $resOrdenSales");

    final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");


        requestBody = {
          "CompositeRequest": {
            "ADLoginRequest": {
              "user": 'jColmenarez',
              "pass": 'St3L30**',
              "lang": 'es_AR',
              "ClientID": "1000000",
              "RoleID": "1000000",
              "OrgID": "1000000",
              "WarehouseID":"1000017",
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
                          "val": resOrdenSales['header']['ad_client_id']
                        },
                        {
                          "@column": "AD_Org_ID",
                          "val": "1000000"
                        },
                        {
                          "@column": "C_BPartner_ID",
                          "val": resOrdenSales['header']['c_bpartner_id'],
                        },
                        {
                          "@column": "C_BPartner_Location_ID",
                          "val": resOrdenSales['header']['c_bpartner_location_id'],
                        },
                        {
                          "@column": "C_Currency_ID",
                          "val": resOrdenSales['header']['c_currency_id'] ,
                        },
                        // {
                        //   "@column": "Description",
                        //   "val": resOrdenSales['header']['description'],
                        // },
                       
                        {
                          "@column": "C_DocTypeTarget_ID",
                          "val": resOrdenSales['header']['c_doctypetarget_id']
                        },
                        {
                          "@column": "C_PaymentTerm_ID",
                          "val": resOrdenSales['header']['c_paymentterm_id']
                        },
                        {
                          "@column": "DateOrdered",
                          "val": dateFormat.format(resOrdenSales['header']['date_ordered'])
                        },
                        {"@column": "IsTransferred", "val": 'Y'},
                        {
                          "@column": "M_PriceList_ID",
                          "val": resOrdenSales['header']['m_pricelist_id']
                        },
                        {
                          "@column": "M_Warehouse_ID",
                          "val": "1000021"
                        },
                        {"@column": "PaymentRule", "val":  resOrdenSales['header']['payment_rule']},
                     
                        {
                          "@column": "GrandTotal",
                          "val": resOrdenSales['header']['grand_total']
                        },
                        // {
                        //   "@column": "C_SalesRegion_ID",
                        //   "val": resOrdenSales['order']['sales_region_id']
                        // },
                       
                        // {
                        //   "@column": "DeliveryRule",
                        //   "val": resOrdenSales['order']['delivery_rule'] ?? 'A'
                        // },
                        // {
                        //   "@column": "DeliveryViaRule",
                        //   "val": resOrdenSales['order']['delivery_via_rule'] ?? 'D'
                        // },
                        // {
                        //   "@column": "InvoiceRule",
                        //   "val": resOrdenSales['order']['invoice_rule'] ?? 'I'
                        // },
            
                        // {
                        //   "@column": "M_DiscountSchema_ID",
                        //   "val": resOrdenSales['order']['m_discount_schema_id'] 
                        // },
                      
                        
                        // {
                        //   "@column": "AD_User_ID",
                        //   "val": resOrdenSales['order']['usuario_id']
                        // },
                        // {
                        //   "@column": "Bill_User_ID",
                        //   "val": resOrdenSales['order']['usuario_id']
                        // },

                        // {"@column": "LVE_PayAgreement_ID", "val": '1000001'},
                        // {"@column": "IsSOTrx", "val": 'Y'}
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
        createLines(resOrdenSales['lines'],resOrdenSales);

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
    String jsonBody = jsonEncode(requestBody);
 
      print('entre aqui despues de que ses agrego el doaction ');

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


  

    return parsedJson;
  } catch (e) {
    return 'este es el error e $e';
  }
}

createLines(lines, order) {
  List linea = [];

  print('Estas son las lineas $lines');

try {
  

   lines.forEach((line) => {

        print("line ${line}"),


            print('Entre en el primer if'),
           

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
                {"@column": "AD_Client_ID", "val":  order['header']['ad_client_id']},
                {"@column": "AD_Org_ID", "val":  '1000000'},
                // {"@column": "M_Warehouse_ID", "val":'1000021'},
                {"@column": "C_Order_ID", "val": "@C_Order.C_Order_ID"},
                {
                  "@column": "PriceEntered",
                  "val":  line['precio']
                },
                {
                  "@column": "PriceActual",
                  "val":   line['precio']
                },
                {"@column": "M_Product_ID", "val": line['product_id']},
                {
                  "@column": "QtyOrdered",
                  "val":  line['quantity']
                },
                //  {
                //   "@column": "PriceList",
                //   "val": line['price'] == 0 || line['price'] == null ?  line['price_actual'] : line['price']
                // },
                //    {
                //   "@column": "Discount",
                //   "val":  line['discount_percent']
                // },
                {
                  "@column": "QtyEntered",
                  "val": line['quantity']
                },
                // {
                //   "@column": "IsDocumentDiscount",
                //   "val":  line['is_document_discount']
                // },
                // {
                //   "@column": "C_UOM_ID",
                //   "val":  line['um_id']
                // },
                // {"@column": "SalesRep_ID", "val": order['salesrep_id']}
              ]
            }
          }
        })

     
      });
} catch (e) {

    print('Este es el error $e');
}
  print("estas son las lineas $linea");

  return linea;
}
