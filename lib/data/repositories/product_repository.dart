import '../models/product.dart';
import '../services/product_api_service.dart';

class ProductRepository {
  final ProductApiService _apiService;

  ProductRepository({ProductApiService? apiService})
      : _apiService = apiService ?? ProductApiService();

  static const int pageSize = 20;

  Future<ProductsResponse> getProducts({required int skip}) {
    return _apiService.fetchProducts(limit: pageSize, skip: skip);
  }

  Future<ProductsResponse> search(String query) {
    return _apiService.searchProducts(query);
  }

  Future<Product> getProductDetail(int id) {
    return _apiService.fetchProductDetail(id);
  }

  bool hasMore(ProductsResponse response) {
    return response.skip + response.products.length < response.total;
  }
}