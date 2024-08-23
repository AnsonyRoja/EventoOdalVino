import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

Future getAllProducts() async {
  // Crear un HttpClient personalizado que ignore la verificación del certificado
  HttpClient client = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

  // Crear un IOClient usando el HttpClient personalizado
  http.Client httpClient = IOClient(client);

  // Configuración del endpoint y headers
  Uri url = Uri.parse('https://parbras.dyndns.info:53659/ADInterface/services/rest/model_adservice/query_data');
  Map<String, String> headers = {
    'Accept': 'application/json; ',
    'Content-Type': 'application/json; charset=utf-8',
  };

  // Construcción del cuerpo de la solicitud
  Map<String, dynamic> requestBody = {
    "ModelCRUDRequest": {
      "ModelCRUD": {
        "serviceType": "getProductVinos"
      },
      "ADLoginRequest": {
        "user": "aRojas",
        "pass": "aRojas",
        "lang": "es_AR",
        "ClientID": "1000000",
        "RoleID": "1000000",
        "OrgID": "1000000",
        "WarehouseID": "1000017",
        "stage": 9
      }
    }
  };
        List vinos = [];


  try {
    http.Response response = await httpClient.post(
      url,
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);

        int count = 0;
       var dataRow = responseData['WindowTabData']['DataSet']['DataRow'];
        for(var data in dataRow){

          var  object = {
              'id':count++,
              'product_name': data['field'].firstWhere((element) => element['@column'] == 'product_name')['val'],
              'm_product_id': data['field'].firstWhere((element)=> element['@column'] == 'M_Product_ID')['val'],
              'value': data['field'].firstWhere((element)=> element['@column'] == 'Value')['val'],
              'description': data['field'].firstWhere((element)=> element['@column'] == 'Description' )['val'],
              'upc': data['field'].firstWhere((element)=> element['@column']=='UPC')['val'],  
              'qty_on_hand': data['field'].firstWhere((element)=> element['@column']=='QtyOnHand')['val'],  
              'image_url': data['field'].firstWhere((element)=> element['@column']=='ImageURL')['val'],  
              'description_url': data['field'].firstWhere((element)=> element['@column']=='DescriptionURL')['val'],  
              'product_group_name': data['field'].firstWhere((element)=> element['@column']=='product_group_name')['val'],  
              'group_id': data['field'].firstWhere((element)=> element['@column']=='group_id')['val'],  
              'product_brand': data['field'].firstWhere((element)=> element['@column']=='product_brand')['val'],
              'product_brand_id': data['field'].firstWhere((element)=> element['@column'] == 'product_brand_id')['val'],            
              'notes': data['field'].firstWhere((element)=> element['@column']=='notes')['val'],  
              'price_list': data['field'].firstWhere((element)=> element['@column']=='PriceList')['val'],  
              'quantity': 0
            };  

          vinos.add(object);
            print('este es el valor del objecto $object');

        }

      print('Estos son los vinos $vinos');
      print('Productos: $responseData');
    return vinos;
    } else {
      print('Error en la solicitud: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    httpClient.close();
  }
}
