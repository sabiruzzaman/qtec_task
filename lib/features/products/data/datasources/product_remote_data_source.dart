import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qtec_task/core/constants/api_constants.dart';
import '../models/product_model.dart';

class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProducts() async {
    final response = await http.get(Uri.parse(ApiConstants.products));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception('Error fetching products');
    }
  }
}
