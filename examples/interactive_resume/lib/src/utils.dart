// Copyright 2025 The Flutter Authors.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class MarkdownWidget extends StatelessWidget {
  const MarkdownWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return GptMarkdown(text, style: Theme.of(context).textTheme.bodyMedium);
  }
}
