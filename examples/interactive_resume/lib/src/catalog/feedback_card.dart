// Copyright 2025 The Flutter Authors.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import '../utils.dart';

final _schema = S.object(
  properties: {
    'score': S.integer(description: 'Score from 1-10.'),
    'strengths': S.list(
      items: S.string(),
      description: 'What was good about the answer.',
    ),
    'improvements': S.list(
      items: S.string(),
      description: 'What could be improved.',
    ),
    'suggestedAnswer': S.string(description: 'An example of a better answer.'),
  },
  required: ['score', 'strengths', 'improvements'],
);

extension type _FeedbackCardData.fromMap(Map<String, Object?> _json) {
  num get score => _json['score'] as num;
  List<String> get strengths => (_json['strengths'] as List).cast<String>();
  List<String> get improvements =>
      (_json['improvements'] as List).cast<String>();
  String? get suggestedAnswer => _json['suggestedAnswer'] as String?;
}

final feedbackCard = CatalogItem(
  name: 'FeedbackCard',
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": {
            "FeedbackCard": {
              "score": 8,
              "strengths": ["Clear communication", "Good examples"],
              "improvements": ["Could be more concise"],
              "suggestedAnswer": "Try focusing on the impact..."
            }
          }
        }
      ]
    ''',
  ],
  widgetBuilder: (context) {
    final data = _FeedbackCardData.fromMap(
      context.data as Map<String, Object?>,
    );
    return _FeedbackCard(data: data);
  },
);

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.data});

  final _FeedbackCardData data;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Score: ${data.score}/10',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: data.score >= 7 ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
            const Divider(),
            const Text(
              'Strengths:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...data.strengths.map((s) => Text('• $s')),
            const SizedBox(height: 8),
            const Text(
              'Improvements:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...data.improvements.map((s) => Text('• $s')),
            if (data.suggestedAnswer != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Suggested Answer:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              MarkdownWidget(text: data.suggestedAnswer!),
            ],
          ],
        ),
      ),
    );
  }
}
