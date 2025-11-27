// Copyright 2025 The Flutter Authors.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class Conversation extends StatelessWidget {
  const Conversation({
    super.key,
    required this.messages,
    required this.manager,
    this.controller,
  });

  final List<ChatMessage> messages;
  final GenUiManager manager;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.all(16.0),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _MessageItem(message: message, manager: manager);
      },
    );
  }
}

class _MessageItem extends StatelessWidget {
  const _MessageItem({required this.message, required this.manager});

  final ChatMessage message;
  final GenUiManager manager;

  @override
  Widget build(BuildContext context) {
    switch (message) {
      case UserMessage():
        final text = (message as UserMessage).parts
            .whereType<TextPart>()
            .map((e) => e.text)
            .join('\n');
        return Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(text),
          ),
        );
      case AiTextMessage():
        final text = (message as AiTextMessage).parts
            .whereType<TextPart>()
            .map((e) => e.text)
            .join('\n');
        if (text.isEmpty) return const SizedBox.shrink();
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: GptMarkdown(text),
          ),
        );
      case AiUiMessage():
        final uiMessage = message as AiUiMessage;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: GenUiSurface(
            key: uiMessage.uiKey,
            host: manager,
            surfaceId: uiMessage.surfaceId,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
