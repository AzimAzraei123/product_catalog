import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog/main.dart';

void main() {
  testWidgets('App renders ProductListScreen with search box',
          (WidgetTester tester) async {
        await tester.pumpWidget(const ProductCatalogApp());

        // Let the initial network call settle (or fail) without hanging the test.
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('Product Catalog'), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });
}