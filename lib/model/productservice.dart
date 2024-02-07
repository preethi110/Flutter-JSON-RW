import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'product.dart';

class ProductService {
  Future<List<Product>> getProducts() async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/sample.json');
      if (await file.exists()) {
        final String jsonData = await file.readAsString();
        if (jsonData.isNotEmpty) {
          final List<dynamic> items = json.decode(jsonData)['items'];
          return items.map((json) => Product.fromJson(json)).toList();
        }
      }
    } catch (e) {
      print('Error reading products: $e');
    }
    return [];
  }

  Future<void> addProduct(Product newProduct) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/sample.json');
      List<dynamic> items = [];
      if (await file.exists()) {
        final String jsonData = await file.readAsString();
        if (jsonData.isNotEmpty) {
          items = json.decode(jsonData)['items'];
        }
      }
      items.add(newProduct.toJson());
      await file.writeAsString(json.encode({'items': items}));
      print('Data added successfully');
    } catch (e) {
      print('Error saving product: $e');
    }
  }
}
