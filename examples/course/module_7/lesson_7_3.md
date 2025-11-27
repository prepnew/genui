# Lesson 7.3: Custom Backend Implementation

While `genui_google_generative_ai` and `genui_firebase_ai` cover most use cases, sometimes you need complete control over the backend. You might want to:
*   Use a different LLM provider (e.g., Anthropic, OpenAI).
*   Route requests through your own server for auditing.
*   Implement custom caching or logic.

The `custom_backend` example demonstrates how to do this.

## The `Backend` Class

In `lib/backend.dart` (of the example), we see a custom `Backend` class. It doesn't implement `ContentGenerator` directly but instead interacts with the `GenUiManager` manually.

```dart
final _protocol = Backend(uiSchema);
final GenUiManager _genUi = GenUiManager(catalog: _catalog);

// Sending a request
final ParsedToolCall? parsedToolCall = await _protocol.sendRequest(userPrompt);

// Handling the response
if (parsedToolCall != null) {
  for (final A2uiMessage message in parsedToolCall.messages) {
    _genUi.handleMessage(message);
  }
}
```

## Parsing A2UI Messages

The core responsibility of a custom backend is to take the raw JSON response from your source and convert it into `A2uiMessage` objects that `GenUiManager` can understand.

The `genui` package provides helper classes for this. The `ParsedToolCall` contains a list of `A2uiMessage`s. These messages are instructions like:
*   `update-component`: Change the properties of a widget.
*   `append-component`: Add a new widget to a list.

By manually feeding these messages into `_genUi.handleMessage(message)`, you drive the UI updates exactly as the standard packages do.

## When to use this?

Use a custom backend when you need to integrate GenUI into an existing architecture that doesn't fit the standard "Direct to LLM" model.
