// Copyright 2025 The Flutter Authors.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:url_launcher/url_launcher.dart';

final _schema = S.object(
  properties: {
    'name': S.string(description: 'The name of the product.'),
    'price': S.string(
      description: 'The price of the product (e.g., "\$99.99").',
    ),
    'imageUrl': S.string(description: 'URL of the product image.'),
    'affiliateLink': S.string(
      description: 'The affiliate link to buy the product.',
    ),
    'rating': S.number(description: 'Rating out of 5.'),
  },
  required: ['name', 'price', 'affiliateLink'],
);

extension type ProductCardData.fromMap(Map<String, Object?> _json) {
  String get name => _json['name'] as String;
  String get price => _json['price'] as String;
  String? get imageUrl => _json['imageUrl'] as String?;
  String get affiliateLink => _json['affiliateLink'] as String;
  num? get rating => _json['rating'] as num?;
}

final productCard = CatalogItem(
  name: 'ProductCard',
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": {
            "ProductCard": {
              "name": "Wireless Headphones",
              "price": "\$199.99",
              "imageUrl": "https://example.com/headphones.jpg",
              "affiliateLink": "https://amazon.com/...",
              "rating": 4.5
            }
          }
        }
      ]
    ''',
  ],
  widgetBuilder: (context) {
    final data = ProductCardData.fromMap(context.data as Map<String, Object?>);
    return ProductCard(data: data);
  },
);

class ProductCard extends StatelessWidget {
  const ProductCard({required this.data});

  final ProductCardData data;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.imageUrl != null && data.imageUrl!.isNotEmpty)
            Image.network(
              data.imageUrl!,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 150,
                color: Colors.grey.shade300,
                child: const Center(child: Icon(Icons.image_not_supported)),
              ),
            )
          else
            Container(
              height: 150,
              color: Colors.grey.shade300,
              child: const Center(child: Icon(Icons.image_not_supported)),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data.price,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (data.rating != null)
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          Text(' ${data.rating}'),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: data.affiliateLink.isNotEmpty
                        ? () => launchUrl(Uri.parse(data.affiliateLink))
                        : null,
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Buy Now'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
