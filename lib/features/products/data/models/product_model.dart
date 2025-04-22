import '../../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.category,
    required super.image,
     super.rating,
    required super.ratingCount,
    required super.isFavorite,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final ratingJson = json['rating'] as Map<String, dynamic>?;

    return ProductModel(
      id: json['id'] as int,
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      image: json['image'] ?? '',
      rating: ratingJson != null
          ? Rating(
        rate: (ratingJson['rate'] as num?)?.toDouble() ?? 0.0,
        count: (ratingJson['count'] as num?)?.toInt() ?? 0,
      )
          : null,
      ratingCount: (ratingJson?['count'] as num?)?.toInt() ?? 0,
      isFavorite: (json['isFavorite'] == 1 || json['isFavorite'] == true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': {
        'rate': rating?.rate ?? 0.0,
        'count': rating?.count ?? 0,
      },
      'ratingCount': ratingCount,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory ProductModel.fromDb(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int,
      title: map['title'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      image: map['image'] ?? '',
      rating: Rating(
        rate: (map['rate'] as num?)?.toDouble() ?? 0.0,
        count: (map['ratingCount'] as num?)?.toInt() ?? 0,
      ),
      ratingCount: (map['ratingCount'] as num?)?.toInt() ?? 0,
      isFavorite: map['isFavorite'] == 1 || map['isFavorite'] == true,
    );
  }


  factory ProductModel.fromEntity(Product p) {
    return ProductModel(
      id: p.id,
      title: p.title,
      price: p.price,
      description: p.description,
      category: p.category,
      image: p.image,
      rating: p.rating != null
          ? Rating(rate: p.rating!.rate, count: p.rating!.count)
          : null,
      ratingCount: p.ratingCount,
      isFavorite: p.isFavorite,
    );
  }
}

class Rating {
  final double rate;
  final int count;

  Rating({
    required this.rate,
    required this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
      count: json['count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'count': count,
    };
  }

  @override
  String toString() => 'Rating(rate: $rate, count: $count)';
}
