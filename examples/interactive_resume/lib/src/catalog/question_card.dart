// Copyright 2025 The Flutter Authors.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  properties: {
    'question': S.string(description: 'The interview question.'),
    'difficulty': S.string(
      description: 'Difficulty level.',
      enumValues: ['Easy', 'Medium', 'Hard'],
    ),
    'category': S.string(
      description: 'Category (e.g., Technical, Behavioral).',
    ),
  },
  required: ['question'],
);

extension type _QuestionCardData.fromMap(Map<String, Object?> _json) {
  String get question => _json['question'] as String;
  String? get difficulty => _json['difficulty'] as String?;
  String? get category => _json['category'] as String?;
}

final questionCard = CatalogItem(
  name: 'QuestionCard',
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": {
            "QuestionCard": {
              "question": "Tell me about a time you faced a challenge.",
              "difficulty": "Medium",
              "category": "Behavioral"
            }
          }
        }
      ]
    ''',
  ],
  widgetBuilder: (context) {
    final data = _QuestionCardData.fromMap(
      context.data as Map<String, Object?>,
    );
    return _QuestionCard(data: data);
  },
);

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.data});

  final _QuestionCardData data;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (data.difficulty != null)
                  Chip(label: Text(data.difficulty!)),
                if (data.category != null) ...[
                  const SizedBox(width: 8),
                  Chip(label: Text(data.category!)),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Text(
              data.question,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const Text(
              'Answer below or tap the microphone to speak.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
