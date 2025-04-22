import 'dart:math';
import '../../products/data/models/product_model.dart';

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating? rating;
  final int ratingCount;
  final bool isFavorite;
  final bool isOutOfStock;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.rating,
    required this.ratingCount,
    this.isFavorite = false,
    bool? isOutOfStock,
  }) : isOutOfStock = isOutOfStock ?? Random().nextBool(); // Out of stock badge using random boolean status


  Product copyWith({
    int? id,
    bool? isFavorite,
    bool? isOutOfStock,
  }) {
    return Product(
      id: id ?? this.id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      rating: rating,
      ratingCount: ratingCount,
      isFavorite: isFavorite ?? this.isFavorite,
      isOutOfStock: isOutOfStock ?? this.isOutOfStock,
    );
  }
}
