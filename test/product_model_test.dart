import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog/data/models/product.dart';

void main() {
  group('Product.fromJson', () {
    test('parses a complete, well-formed JSON object correctly', () {
      final json = {
        'id': 1,
        'title': 'iPhone 9',
        'description': 'An apple mobile phone',
        'price': 549,
        'rating': 4.69,
        'thumbnail': 'https://example.com/thumb.jpg',
        'images': ['https://example.com/1.jpg', 'https://example.com/2.jpg'],
        'category': 'smartphones',
        'discountPercentage': 12.96,
        'stock': 94,
      };

      final product = Product.fromJson(json);

      expect(product.id, 1);
      expect(product.title, 'iPhone 9');
      expect(product.price, 549.0);
      expect(product.rating, 4.69);
      expect(product.images.length, 2);
      expect(product.category, 'smartphones');
    });

    test('handles missing optional fields without throwing', () {
      final json = {'id': 2};

      final product = Product.fromJson(json);

      expect(product.id, 2);
      expect(product.title, '');
      expect(product.price, 0.0);
      expect(product.images, isEmpty);
    });

    test('handles price given as an int instead of double', () {
      final json = {'id': 3, 'price': 100};

      final product = Product.fromJson(json);

      expect(product.price, 100.0);
      expect(product.price, isA<double>());
    });
  });

  group('ProductsResponse.fromJson', () {
    test('parses a list of products and pagination metadata', () {
      final json = {
        'products': [
          {'id': 1, 'title': 'A'},
          {'id': 2, 'title': 'B'},
        ],
        'total': 100,
        'skip': 0,
        'limit': 20,
      };

      final response = ProductsResponse.fromJson(json);

      expect(response.products.length, 2);
      expect(response.total, 100);
      expect(response.skip, 0);
    });
  });
}