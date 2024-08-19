import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart'; // Importa IOClient desde esta biblioteca

Future<void> getAllProducts() async {
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

  try {
    http.Response response = await httpClient.post(
      url,
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      print('Productos: $responseData');
    } else {
      print('Error en la solicitud: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    httpClient.close();
  }
}
