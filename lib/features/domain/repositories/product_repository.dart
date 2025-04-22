import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<List<Product>> getProductsFromLocal();
  Future<void> toggleFavorite(int productId, bool isFavorite);
}
