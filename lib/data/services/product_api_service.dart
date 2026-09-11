import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductApiService {
  static const String _baseUrl = 'https://dummyjson.com';

  Future<ProductsResponse> fetchProducts({
    required int limit,
    required int skip,
  }) async {
    final uri = Uri.parse('$_baseUrl/products?limit=$limit&skip=$skip');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw ApiException(
        'Failed to load products (status ${response.statusCode})',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return ProductsResponse.fromJson(json);
  }

  Future<ProductsResponse> searchProducts(String query) async {
    final uri = Uri.parse(
      '$_baseUrl/products/search?q=${Uri.encodeQueryComponent(query)}',
    );
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw ApiException(
        'Search failed (status ${response.statusCode})',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return ProductsResponse.fromJson(json);
  }

  Future<Product> fetchProductDetail(int id) async {
    final uri = Uri.parse('$_baseUrl/products/$id');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw ApiException(
        'Failed to load product $id (status ${response.statusCode})',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return Product.fromJson(json);
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}