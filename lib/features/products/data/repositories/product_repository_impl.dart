import '../../../domain/entities/product.dart';
import '../../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });


  @override
  Future<List<Product>> getProducts() async {
    final remoteProducts = await remoteDataSource.fetchProducts();
    final localProducts = await localDataSource.getCachedProducts();

    /// Make a Map of favorite product IDs
    final favoriteMap = {
      for (var p in localProducts.where((e) => e.isFavorite)) p.id: true
    };

    /// Merge isFavorite from local into remote
    final mergedProducts = remoteProducts.map((product) {
      final isFavorite = favoriteMap[product.id] ?? false;
      return product.copyWith(isFavorite: isFavorite);
    }).toList();

    /// Convert to ProductModel and cache
    final productModels = mergedProducts.map((p) => ProductModel.fromEntity(p)).toList();
    await localDataSource.cacheProducts(productModels);

    return mergedProducts;
  }

  /// Cache products to local storage
  @override
  Future<List<Product>> getProductsFromLocal() {
    return localDataSource.getCachedProducts();
  }

  /// Toggle favorite status of a product
  @override
  Future<void> toggleFavorite(int productId, bool isFavorite) async {
    await localDataSource.toggleFavorite(productId, isFavorite);
  }
}


