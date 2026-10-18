class Product {
  const Product({
    required this.name,
    required this.brand,
    required this.price,
    required this.image,
    required this.category,
    this.oldPrice,
    this.discount,
    this.rating = 4.5,
  });

  final String name;
  final String brand;
  final double price;
  final double? oldPrice;
  final String image;
  final String category;
  final String? discount;
  final double rating;
}
