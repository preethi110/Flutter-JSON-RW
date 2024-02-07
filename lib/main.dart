// main.dart
import 'package:flutter/material.dart';
import 'package:yelebo/addproduct.dart';
import 'package:yelebo/model/productservice.dart';
import 'model/product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductService _productService = ProductService();
  late List<Product> _items;
  late List<Product> _filteredItems;
  late List<String> _categories;
  String _selectedCategory = 'None';

  @override
  void initState() {
    super.initState();
    _items = [];
    _filteredItems = [];
    _categories = [];
    _loadData();
  }

  Future<void> _loadData() async {
    final products = await _productService.getProducts();
    setState(() {
      _items = products;
      _filteredItems = List.from(_items);
      _categories = [
        'None',
        ..._items
            .map((product) => product.category)
            .where((category) =>
                category != null && category.isNotEmpty)
            .toSet()
            .toList()
      ];
    });
  }

  void _filterProductsByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      if (_selectedCategory == 'None') {
        _filteredItems = List.from(_items);
      } else {
        _filteredItems = _items
            .where((product) => product.category == _selectedCategory)
            .toList();
      }
    });
  }

  Future<void> _addProduct(Product newProduct) async {
    await _productService.addProduct(newProduct);
    _loadData(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Color.fromARGB(255, 239, 151, 151), 
        title: const Text('Product App'),
actions: [
  
  Padding(
    padding: const EdgeInsets.only(right: 20.0, top: 10.0, bottom: 10.0),
    child: GestureDetector(
     onTap: () async {
    final newProduct = await showDialog<Product>(
      context: context,
      builder: (context) => AddProductDialog(
        reloadData: _loadData,
      ),
    );
    if (newProduct != null) {
      _addProduct(newProduct);
    }
  },
      child: Container(
        width: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white.withOpacity(0.5),
        ),
        child: Center(
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ),
    ),
  ),
],
      ),
    
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField(
              value: _selectedCategory,
              items: _categories
                  .map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  })
                  .toList(),
              onChanged: (value) {
                _filterProductsByCategory(value.toString());
              },
              decoration: InputDecoration(
                
                labelText: 'Select Category',
              border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0), 
        borderSide: BorderSide(color: Color.fromARGB(255, 205, 205, 205)),
    ),
              ),
            ),
            SizedBox(height: 20),
            _filteredItems.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
  itemCount: _filteredItems.length,
  itemBuilder: (context, index) {
    final product = _filteredItems[index];
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/fruits.png'), 
            ),
          ),
        ),
        title: Text(
          product.name,
          style: TextStyle(
            color: Colors.black87, 
            fontWeight: FontWeight.bold, 
          ),
        ),
        subtitle: Text(product.details),
        trailing: Text('\$${product.cost.toString()}'),
      ),
    );
  },
),

                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
      ),
    );
  }
}
