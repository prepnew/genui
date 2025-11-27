// Copyright 2025 The Flutter Authors.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:logging/logging.dart';

import 'src/catalog/product_card.dart';
import 'src/n8n_backend.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(const ShoppingApp());
}

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Shopping Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ShoppingPage(),
    );
  }
}

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  late final GenUiConversation _uiConversation;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _webhookController = TextEditingController(
    text: 'https://n8n.prepnew.com/webhook/chat',
  );
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
  }

  void _connect() {
    if (_webhookController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your n8n Webhook URL')),
      );
      return;
    }

    final catalog = CoreCatalogItems.asCatalog().copyWith([productCard]);
    final generator = N8nContentGenerator(
      webhookUrl: _webhookController.text,
      catalog: catalog,
    );

    _uiConversation = GenUiConversation(
      genUiManager: GenUiManager(catalog: catalog),
      contentGenerator: generator,
      onSurfaceAdded: (_) => _scrollToBottom(),
      onTextResponse: (_) => _scrollToBottom(),
    );

    setState(() {
      _isConnected = true;
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    _uiConversation.sendRequest(UserMessage.text(text));
    _scrollToBottom();
  }

  @override
  void dispose() {
    if (_isConnected) {
      _uiConversation.dispose();
    }
    _scrollController.dispose();
    _textController.dispose();
    _webhookController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isConnected) {
      return Scaffold(
        appBar: AppBar(title: const Text('Setup Connection')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter your n8n Webhook URL',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _webhookController,
                decoration: const InputDecoration(
                  hintText: 'https://your-n8n-instance.com/webhook/...',
                  border: OutlineInputBorder(),
                  labelText: 'Webhook URL',
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: _connect, child: const Text('Connect')),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Assistant'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.link_off),
            onPressed: () {
              setState(() {
                _isConnected = false;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _uiConversation.conversation,
              builder: (context, messages, _) {
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _MessageBubble(
                      message: message,
                      manager: _uiConversation.genUiManager,
                    );
                  },
                );
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _uiConversation.isProcessing,
            builder: (context, isProcessing, _) {
              if (isProcessing) {
                return const LinearProgressIndicator();
              }
              return const SizedBox.shrink();
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Ask for product suggestions...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.manager});

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
            child: Text(text),
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
