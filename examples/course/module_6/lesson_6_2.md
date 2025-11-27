# Lesson 6.2: Reactive Data Binding

One of the most powerful features of GenUI is its **Reactive Data Binding**. This allows the UI to update in real-time as the AI streams data or as the user interacts with inputs.

## The `DataContext`

Every widget built by the `GenUiManager` has access to a `DataContext`. This is a shared repository of data for the current UI surface.

## Subscribing to Data

In your `widgetBuilder`, you don't just read values once. You subscribe to them.

```dart
// lib/src/catalog/information_card.dart

final ValueNotifier<String?> titleNotifier = context.dataContext
    .subscribeToString(cardData.title);
```

Here, `cardData.title` is a `JsonMap` that describes *where* the data comes from (either a literal string or a path).

-   If it's a literal: The notifier has an initial value and never changes.
-   If it's a path (e.g., `/search/destination`): The notifier updates whenever that path in the `DataContext` changes.

## Using the Notifier

You then use this `ValueNotifier` in your widget tree, typically with a `ValueListenableBuilder`:

```dart
ValueListenableBuilder<String?>(
  valueListenable: titleNotifier,
  builder: (context, title, _) => Text(title ?? ''),
),
```

This ensures that if the AI decides to change the title of the card later in the stream, your Flutter widget updates automatically without needing a full rebuild.

## Lesson 6.3: Handling User Interactions

Interaction is a two-way street. Users need to be able to send information back to the AI.

### Dispatching Events

Let's look at `lib/src/catalog/trailhead.dart`. This widget displays chips that the user can click.

```dart
// lib/src/catalog/trailhead.dart

onPressed: () {
  // 1. Get the action name defined by the AI
  final name = action['name'] as String;

  // 2. Prepare the context data
  final JsonMap resolvedContext = resolveContext(dataContext, contextDefinition);
  resolvedContext['topic'] = topic;

  // 3. Dispatch the event
  dispatchEvent(
    UserActionEvent(
      name: name,
      sourceComponentId: widgetId,
      context: resolvedContext,
    ),
  );
},
```

When `dispatchEvent` is called:
1.  The `GenUiManager` receives the event.
2.  It forwards it to the `GenUiConversation`.
3.  The conversation sends a message to the AI: "User performed action 'select_topic' with context { topic: 'History' }".
4.  The AI receives this message and generates a new response (e.g., a new itinerary focused on history).

This loop—**AI generates UI -> User interacts -> Event sent to AI -> AI generates new UI**—is the core loop of a GenUI application.
