import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product_model.dart';

class ProductLocalDataSource {
  static const _dbName = 'products.db';
  static const _table = 'products';

  Future<Database> get database async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE $_table(
            id INTEGER PRIMARY KEY,
            title TEXT,
            price REAL,
            description TEXT,
            category TEXT,
            image TEXT,
            rate REAL,
            ratingCount INTEGER,
            isFavorite INTEGER
          )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<void> cacheProducts(List<ProductModel> products) async {
    final db = await database;
    final batch = db.batch();


    for (var product in products) {
      batch.insert(
        _table,
        {
          'id': product.id,
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'category': product.category,
          'image': product.image,
          'rate': product.rating?.rate ?? 0.0,
          'ratingCount': product.rating?.count ?? 0,
          'isFavorite': product.isFavorite ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
    print('[log] Cached ${products.length} products to local DB');
  }

  Future<List<ProductModel>> getCachedProducts() async {
    final db = await database;
    final maps = await db.query(_table);
    print('[log] Loaded ${maps.length} products from local DB');

    final products = List.generate(maps.length, (i) {
      final jsonString = JsonEncoder.withIndent('  ').convert(maps[i]);
      print('[log] JSON for Product ${i + 1}: $jsonString');
      return ProductModel.fromDb(maps[i]);
    });

    return products;
  }

  Future<void> toggleFavorite(int productId, bool isFavorite) async {
    final db = await database;
    await db.update(
      _table,
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [productId],
    );
  }
}
