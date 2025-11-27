import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:n8n_shopping_app/src/catalog/product_card.dart';

void main() {
  testWidgets('ProductCard renders correctly with simple JSON data', (
    tester,
  ) async {
    final data = {
      'name': 'Test Product',
      'price': '\$10.00',
      'imageUrl': 'https://example.com/image.png',
      'affiliateLink': 'https://example.com/buy',
      'rating': 4.5,
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ProductCard(data: ProductCardData.fromMap(data))),
      ),
    );

    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('\$10.00'), findsOneWidget);
    expect(find.text(' 4.5'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Buy Now'), findsOneWidget);
  });

  testWidgets('ProductCard handles missing optional fields', (tester) async {
    final data = {
      'name': 'Test Product',
      'price': '\$10.00',
      'affiliateLink': 'https://example.com/buy',
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ProductCard(data: ProductCardData.fromMap(data))),
      ),
    );

    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('\$10.00'), findsOneWidget);
    expect(find.byType(Image), findsNothing); // No image
    expect(
      find.byIcon(Icons.image_not_supported),
      findsOneWidget,
    ); // Placeholder
    expect(find.text('Buy Now'), findsOneWidget);
  });
}
