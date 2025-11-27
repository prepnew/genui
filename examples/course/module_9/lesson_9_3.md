# Lesson 9.3: The Flutter Client

The Flutter client in an A2A architecture is surprisingly simple. Its main job is to render the UI requested by the server.

## Connecting to the Agent

In `client/lib/main.dart` (of `verdure`), the client connects to the server using a `RemoteAgent`.

```dart
final agent = RemoteAgent(
  url: 'http://localhost:8000',
  // ...
);
```

## The `GenUiManager`

Just like in the local examples, we use `GenUiManager` to handle the UI generation. However, instead of a local `ContentGenerator`, the manager receives messages directly from the `RemoteAgent`.

```dart
// client/lib/features/home/home_screen.dart

void _onMessageReceived(A2uiMessage message) {
  _genUiManager.handleMessage(message);
}
```

## Handling the Handshake

When the app starts, it performs a handshake with the server to get the initial state.

```dart
// client/lib/features/home/home_screen.dart

@override
void initState() {
  super.initState();
  _connectToAgent();
}

Future<void> _connectToAgent() async {
  // 1. Connect
  await agent.connect();

  // 2. Get the Agent Card (metadata about the agent)
  final card = await agent.getAgentCard();

  // 3. Start the session
  await agent.startSession();
}
```

## Conclusion

The A2A architecture separates concerns perfectly:
*   **Server**: Owns the "Brain" (Logic, Tools, State).
*   **Client**: Owns the "Body" (Rendering, User Input).

This allows you to build powerful, secure, and scalable GenUI applications.
