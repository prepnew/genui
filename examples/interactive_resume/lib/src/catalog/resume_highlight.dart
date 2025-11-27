// Copyright 2025 The Flutter Authors.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import '../utils.dart';

final _schema = S.object(
  properties: {
    'sectionTitle': S.string(
      description: 'Title of the section (e.g., "Experience").',
    ),
    'content': S.string(description: 'The text content of that section.'),
    'annotation': S.string(
      description: 'Why this section is relevant to the current topic.',
    ),
  },
  required: ['sectionTitle', 'content'],
);

extension type _ResumeHighlightData.fromMap(Map<String, Object?> _json) {
  String get sectionTitle => _json['sectionTitle'] as String;
  String get content => _json['content'] as String;
  String? get annotation => _json['annotation'] as String?;
}

final resumeHighlight = CatalogItem(
  name: 'ResumeHighlight',
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": {
            "ResumeHighlight": {
              "sectionTitle": "Experience",
              "content": "Senior Flutter Developer...",
              "annotation": "This shows your leadership skills."
            }
          }
        }
      ]
    ''',
  ],
  widgetBuilder: (context) {
    final data = _ResumeHighlightData.fromMap(
      context.data as Map<String, Object?>,
    );
    return _ResumeHighlight(data: data);
  },
);

class _ResumeHighlight extends StatelessWidget {
  const _ResumeHighlight({required this.data});

  final _ResumeHighlightData data;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.sectionTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            MarkdownWidget(text: data.content),
            if (data.annotation != null) ...[
              const Divider(),
              Text(
                '💡 ${data.annotation}',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
