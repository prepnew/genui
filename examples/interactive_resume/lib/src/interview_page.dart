// Copyright 2025 The Flutter Authors.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_google_generative_ai/genui_google_generative_ai.dart';
import 'package:logging/logging.dart';

import 'catalog/catalog.dart';
import 'config/api_key.dart';
import 'tools/resume_tools.dart';
import 'widgets/conversation.dart';

class InterviewPage extends StatefulWidget {
  const InterviewPage({super.key});

  @override
  State<InterviewPage> createState() => _InterviewPageState();
}

class _InterviewPageState extends State<InterviewPage> {
  late final GenUiConversation _uiConversation;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeGenUi();
  }

  void _initializeGenUi() {
    final genUiManager = GenUiManager(catalog: resumeCatalog);

    final contentGenerator = GoogleGenerativeAiContentGenerator(
      catalog: resumeCatalog,
      apiKey: getApiKey(),
      additionalTools: [GetResumeContentTool()],
      systemInstruction: '''
You are an expert Interview Coach and Career Advisor.
Your goal is to help the user (the candidate) practice for interviews and improve their resume.

You have access to the user's resume via the `getResumeContent` tool.
ALWAYS call this tool at the beginning of the conversation to understand the user's background.

## Capabilities

1. **Introduction Helper**: If the user asks for help introducing themselves, analyze their resume and suggest 3 styles (Professional, Creative, Concise).
2. **Interview Practice**:
   - Ask the user a question using `QuestionCard`.
   - When the user answers, analyze their answer and provide feedback using `FeedbackCard`.
3. **Resume Analysis**:
   - If discussing a specific experience, use `ResumeHighlight` to show that section.

## Rules

- Be encouraging but constructive.
- Always prefer using UI components (`QuestionCard`, `FeedbackCard`, `ResumeHighlight`) over plain text when appropriate.
- If the user asks a question unrelated to their career or resume, politely steer them back to the topic.
''',
    );

    _uiConversation = GenUiConversation(
      genUiManager: genUiManager,
      contentGenerator: contentGenerator,
      onSurfaceAdded: (_) => _scrollToBottom(),
      onTextResponse: (_) => _scrollToBottom(),
      onError: (error) {
        Logger(
          'InterviewPage',
        ).severe('GenUI Error', error.error, error.stackTrace);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${error.error}')));
        }
      },
    );
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
    _uiConversation.dispose();
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Resume Coach'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _uiConversation.conversation,
              builder: (context, messages, _) {
                return Conversation(
                  messages: messages,
                  manager: _uiConversation.genUiManager,
                  controller: _scrollController,
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
                      hintText: 'Type a message...',
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
