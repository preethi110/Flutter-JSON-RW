import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart'; 
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yelebo/model/product.dart';
import 'package:yelebo/model/productservice.dart';

class AddProductDialog extends StatefulWidget {
  final void Function() reloadData; 
  const AddProductDialog({Key? key, required this.reloadData}) : super(key: key);

  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}


class _AddProductDialogState extends State<AddProductDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  
  final ProductService _productService = ProductService();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Product'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _costController,
              decoration: InputDecoration(labelText: 'Cost'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _availabilityController,
              decoration: InputDecoration(labelText: 'Availability'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _detailsController,
              decoration: InputDecoration(labelText: 'Details'),
            ),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _addItemAndSave();
          setState((){});
            Navigator.of(context).pop();
          }, 
          child: Text('Submit'),
        ),
      ],
    );
  }

 
Future<void> _addItemAndSave() async {
  try {
    
    final newProduct = Product(
      name: _nameController.text,
      id: int.parse(_idController.text),
      cost: double.parse(_costController.text),
      availability: int.parse(_availabilityController.text),
      details: _detailsController.text,
      category: _categoryController.text,
    );


    await _productService.addProduct(newProduct);
  widget.reloadData();
   
    Navigator.of(context).pop();
  } catch (e) {
    print('Error saving product: $e');
  }
}

}
