import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:odalvinoeventoapp/presentations/backend/peticiones_http/get_products_http.dart';

class ProductProvider extends ChangeNotifier {
  List<dynamic> _listProducts = [];
  List<dynamic> _filteredProducts = [];
  List<dynamic> _carShop = [];
    bool _isLoading = true;

  
  // Getters para acceder a las listas
  List<dynamic> get filteredProducts => _filteredProducts;
  List<dynamic> get carShop => _carShop;
    bool get isLoading => _isLoading;

  // Cargar productos desde un API o base de datos
  Future<void> getProductsWines() async {
  _isLoading = true;  // Asegúrate de que isLoading sea true antes de cargar
  notifyListeners();  // Notifica a los oyentes que el estado ha cambiado

  try {
    _listProducts = await getAllProducts();  // Obtener productos de la API
    // print("Productos cargados: $_listProducts");  // Para depuración
    _filteredProducts = List.from(_listProducts);
  } catch (e) {
    print("Error al obtener productos: $e");  // Muestra el error si algo sale mal
  } finally {
    _isLoading = false;  // Cambia el estado de carga a false después de intentar cargar
    notifyListeners();  // Notifica a los oyentes que el estado ha cambiado
  }
}


  // Filtrar productos basados en una búsqueda
  void filteredProduct(String searchTerm) {
    _filteredProducts = _listProducts.where((product) {
      final productName = product['product_name'].toString().toLowerCase();
      final productCat = product['product_brand'].toString().toLowerCase();
      final barCode = product['upc'].toString().toLowerCase();
      return productName.contains(searchTerm.toLowerCase()) ||
          productCat.contains(searchTerm.toLowerCase()) ||
          barCode.contains(searchTerm.toLowerCase());
    }).toList();
    notifyListeners();
  }

  // Añadir producto al carrito
  void addProductsToCar(int index) {
    var itemsForCarShop = {
      'id': index + 1,
      'fecha': DateTime.now().toString(),
      'product_name': _filteredProducts[index]['product_name'],
      'product_brand': _filteredProducts[index]['product_brand'],
      'image_url': _filteredProducts[index]['image_url'],
      'stock': _filteredProducts[index]['qty_on_hand'],
      'quantity': _filteredProducts[index]['quantity'],
      'product_id': _filteredProducts[index]['m_product_id'],
      'precio': _filteredProducts[index]['price_list'],
    };

    if (itemsForCarShop['quantity'] == 0) {
      _carShop.clear();
      return;
    }

    var existingProduct = _carShop.firstWhere(
      (value) => value['product_id'] == itemsForCarShop['product_id'],
      orElse: () => {},
    );

    if (existingProduct.isNotEmpty) {
      existingProduct['quantity'] += itemsForCarShop['quantity'];
    } else {
      _carShop.add(itemsForCarShop);
    }

    localStorage.setItem('carShop', jsonEncode(_carShop));
    notifyListeners();
  }

  // Incrementar la cantidad de un producto en el carrito
  void increaseQuantity(int index) {
    int qty = int.parse(_filteredProducts[index]['quantity'].toString());
    double stock = double.parse(_filteredProducts[index]['qty_on_hand'].toString());

    if (qty >= 0 && qty < stock) {
      _filteredProducts[index]['quantity']++;
      notifyListeners();
    }
  }

  // Decrementar la cantidad de un producto en el carrito
  void decreaseQuantity(int index) {
    if (_filteredProducts[index]['quantity'] <= 0) {
      return;
    }

    _filteredProducts[index]['quantity']--;

    var carShopNew = _carShop.firstWhere(
      (value) => value['product_id'] == index + 1,
      orElse: () => {},
    );

    if (carShopNew.isNotEmpty) {
      carShopNew['quantity'] = _filteredProducts[index]['quantity'];
    }

    localStorage.setItem('carShop', jsonEncode(_carShop));
    notifyListeners();
  }

  // Eliminar producto del carrito
  void removeProductsToCar(int index) {
    _carShop.removeWhere((value) => value['id'] == index + 1);
    localStorage.setItem('carShop', jsonEncode(_carShop));
    notifyListeners();
  }
}
