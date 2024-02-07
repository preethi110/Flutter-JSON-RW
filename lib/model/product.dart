class Product {
  final String name;
  final int id;
  final double cost;
  final int availability;
  final String details;
  final String category;

  Product({
    required this.name,
    required this.id,
    required this.cost,
    required this.availability,
    required this.details,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['p_name'],
      id: json['p_id'],
      cost: json['p_cost'].toDouble(),
      availability: json['p_availability'],
      details: json['p_details'] ?? "",
      category: json['p_category'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'p_name': name,
      'p_id': id,
      'p_cost': cost,
      'p_availability': availability,
      'p_details': details,
      'p_category': category,
    };
  }
}
