import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future getVoucherHttp(String cupon) async {
  HttpClient httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) {
      return true;
    };

  final uri = Uri.parse('https://parbras.dyndns.info:53659/ADInterface/services/rest/model_adservice/query_data');

  final request = await httpClient.postUrl(uri);

  // Configurar el cuerpo de la solicitud en formato JSON
  final requestBody = {
    "ModelCRUDRequest": {
      "ModelCRUD": {
        "serviceType": "getVoucher",
        "DataRow": {
          "field": [
            {
              "@column": "Value",
              "val": cupon
            }
          ]
        }
      },
      "ADLoginRequest": {
        "user": 'jColmenarez',
        "pass": 'St3L30**',
        "lang": "1000000",
        "ClientID": "1000000",
        "RoleID": "1000000",
        "OrgID": "1000000",
        "WarehouseID": "1000017",
        "stage": 9
      }
    }
  };

  // Convertir el cuerpo a JSON
  final jsonBody = jsonEncode(requestBody);

  // Establecer las cabeceras de la solicitud
  request.headers.set('Content-Type', 'application/json; charset=utf-8');
  request.headers.set('Accept', 'application/json');

  // Escribir el cuerpo en la solicitud
  request.write(jsonBody);

  // Obtener la respuesta de iDempiere
  final response = await request.close();
  final responseBody = await response.transform(utf8.decoder).join();
  final parsedJson = jsonDecode(responseBody);
  print('ParsedJson en Search Invoice $parsedJson');

  if (parsedJson['WindowTabData']['@NumRows'] == 0) {
    return false;
  }

  final dataRow = parsedJson['WindowTabData']['DataSet']['DataRow'];
  print('esto es el dataRow $dataRow');
  print("Esta es la respuesta Search id Invoiced $parsedJson");

  Directory supportDirectory = await getApplicationSupportDirectory();
  String filePath = '${supportDirectory.path}/.env';
  File configP = File(filePath);

  if (!await configP.exists()) {
    await configP.create();
    await configP.writeAsString('[]'); // Initialize with an empty list
  }

  // Read existing coupons from the file
  String content = await configP.readAsString();
  List<dynamic> couponsList = jsonDecode(content);

  // Check if the coupon already exists
  Map<String, dynamic>? existingCoupon = couponsList.firstWhere(
    (coupon) => coupon['cupon'] == cupon,
    orElse: () => null,
  );

  if (existingCoupon != null) {
    if (existingCoupon['used'] == true) {
      return 'Cupon Usado';
    } else {
      // Update existing coupon details if needed
      // ... (Update fields if necessary)
      existingCoupon['used'] = false;
    }
  } else {
    // If coupon does not exist, create a new entry
    Map<String, dynamic> newCoupon = {
      "cupon": cupon,
      "ad_client_id": dataRow['field'].firstWhere((value) => value['@column'] == "AD_Client_ID")['val'],
      "ad_org_id": dataRow['field'].firstWhere((value) => value['@column'] == 'AD_Org_ID')['val'],
      "c_currency_id": dataRow['field'].firstWhere((value) => value['@column'] == 'C_Currency_ID')['val'],
      "amount": dataRow['field'].firstWhere((value) => value['@column'] == "Amount")['val'],
      "c_bpartner_id": dataRow['field'].firstWhere((value) => value['@column'] == "C_BPartner_ID")['val'],
      "bp_name": dataRow['field'].firstWhere((value) => value['@column'] == 'BPName')['val'],
      "payment_rule": dataRow['field'].firstWhere((value) => value['@column'] == 'PaymentRule')['val'],
      "invoice_rule": dataRow['field'].firstWhere((value) => value['@column'] == 'InvoiceRule')['val'],
      "delivery_rule": dataRow['field'].firstWhere((value) => value['@column'] == 'DeliveryRule')['val'],
      "c_payment_term_id": dataRow['field'].firstWhere((value) => value['@column'] == 'C_PaymentTerm_ID')['val'],
      "c_bpartner_location_id": dataRow['field'].firstWhere((value) => value['@column'] == 'C_BPartner_Location_ID')['val'],
      "c_sales_region_id": dataRow['field'].firstWhere((value) => value['@column'] == 'C_SalesRegion_ID')['val'],
      "phone": dataRow['field'].firstWhere((value) => value['@column'] == 'Phone')['val'],
      "email": dataRow['field'].firstWhere((value) => value['@column'] == 'EMail')['val'].toString() != '{@nil: true}' ? dataRow['field'].firstWhere((value) => value['@column'] == 'EMail')['val'] : "",
      "address1": dataRow['field'].firstWhere((value) => value['@column'] == 'Address1')['val'],
      "address2": dataRow['field'].firstWhere((value) => value['@column'] == 'Address2')['val'],
      "city": dataRow['field'].firstWhere((value) => value['@column'] == 'City')['val'],
      "region_name": dataRow['field'].firstWhere((value) => value['@column'] == 'RegionName')['val'],
      "country_code": dataRow['field'].firstWhere((value) => value['@column'] == 'CountryCode')['val'],
      "postal": dataRow['field'].firstWhere((value) => value['@column'] == 'Postal')['val'],
      "iso_code": dataRow['field'].firstWhere((value) => value['@column'] == 'ISO_Code')['val'],
      "used": false,
      "login": true,
      
    };

    couponsList.add(newCoupon);
  }

  String filePathCoupon = '${supportDirectory.path}/.cupon';
  File configC = File(filePathCoupon);

  if (!await configC.exists()) {
    await configC.create();
  }
  
  configC.writeAsString(jsonEncode({"cupon": cupon}));

  // Read existing coupons from the file
  String contentC = await configP.readAsString();

  print('este es el contentC $contentC');

  // Write the updated list back to the file
  await configP.writeAsString(jsonEncode(couponsList));

  print('Updated Coupons List: $couponsList');

  return true;
}
