// Copyright 2025 The Flutter Authors.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class N8nContentGenerator implements ContentGenerator {
  final String webhookUrl;
  final Catalog catalog;
  final _logger = Logger('N8nContentGenerator');

  final _messageController = StreamController<A2uiMessage>.broadcast();
  final _textController = StreamController<String>.broadcast();
  final _errorController = StreamController<ContentGeneratorError>.broadcast();
  final _isProcessing = ValueNotifier<bool>(false);

  N8nContentGenerator({required this.webhookUrl, required this.catalog});

  @override
  Stream<A2uiMessage> get a2uiMessageStream => _messageController.stream;

  @override
  Stream<String> get textResponseStream => _textController.stream;

  @override
  Stream<ContentGeneratorError> get errorStream => _errorController.stream;

  @override
  ValueListenable<bool> get isProcessing => _isProcessing;

  @override
  void dispose() {
    _messageController.close();
    _textController.close();
    _errorController.close();
    _isProcessing.dispose();
  }

  @override
  Future<void> sendRequest(
    ChatMessage message, {
    Iterable<ChatMessage>? history,
  }) async {
    if (message is! UserMessage) return;

    _isProcessing.value = true;
    final prompt = message.parts.whereType<TextPart>().first.text;
    _logger.info('Sending prompt to n8n: $prompt');

    try {
      final response = await http.post(
        Uri.parse(webhookUrl),
        body: jsonEncode({'prompt': prompt}),
        headers: {'Content-Type': 'application/json'},
      );

      _logger.info('Received response from n8n: ${response.statusCode}');
      _logger.info('Received response from n8n: ${response.body}');
      if (response.statusCode != 200) {
        _errorController.add(
          ContentGeneratorError(
            'Error connecting to backend: ${response.statusCode}',
            StackTrace.current,
          ),
        );
        return;
      }

      final List<dynamic> data = jsonDecode(response.body);

      for (final item in data) {
        try {
          if (item['type'] == 'text') {
            _logger.info('Processing text item: ${item['content']}');
            _textController.add(item['content'] as String);
          } else if (item['type'] == 'ui') {
            _logger.info('Processing UI item: ${item['component']}');
            final componentName = item['component'] as String;
            _logger.info('Component name: ${item['data']}');
            final rawData = item['data'] as Map<String, dynamic>;

            // Transform data to match stringReference schema
            final componentData = rawData;

            _logger.info('Transformed data: $componentData');

            final toolCall = ToolCall(name: componentName, args: componentData);

            final parsed = parseToolCall(toolCall, componentName);

            _logger.info(
              'Parsed tool call with ${parsed.messages.length} messages',
            );
            for (final msg in parsed.messages) {
              _messageController.add(msg);
            }
          }
        } catch (e, stack) {
          _logger.warning('Error processing item: $item', e, stack);
          // Don't stop processing other items
        }
      }
    } catch (e, stack) {
      _logger.severe('Error processing n8n response', e, stack);
      _errorController.add(ContentGeneratorError(e, stack));
    } finally {
      _isProcessing.value = false;
    }
  }
}
