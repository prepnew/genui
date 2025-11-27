# Lesson 4.2: Static vs. Dynamic Data

One of the most important concepts in GenUI is the difference between static configuration and dynamic, reactive data.

## `S.string` vs `A2uiSchemas.stringReference`

When defining your schema, you have two choices for string fields:

### 1. `S.string` (Static)
Use this for values that are fixed for the lifetime of the widget.
*   **Examples**: Widget IDs, labels for buttons, enum values.
*   **In Dart**: Maps to `String`.
*   **In JSON**: `"imageChildId": "image1"`

### 2. `A2uiSchemas.stringReference` (Dynamic)
Use this for values that might change or need to be bound to a data model.
*   **Examples**: User input values, titles that might update, status messages.
*   **In Dart**: Maps to `JsonMap` (a Map).
*   **In JSON**:
    ```json
    "title": {
      "literalString": "Paris"
    }
    // OR
    "title": {
      "path": "/search/destination"
    }
    ```

## Case Study: `DateInputChip`

Let's look at `lib/src/catalog/date_input_chip.dart`:

```dart
final _schema = S.object(
  properties: {
    'value': A2uiSchemas.stringReference(
      description: 'The initial date...',
    ),
    'label': S.string(description: 'Label for the date picker.'),
  },
);
```

*   **`label` is `S.string`**: The label "Check-in Date" doesn't need to change.
*   **`value` is `stringReference`**: The actual date selected by the user *must* be dynamic.

## Handling Data Binding

In the `widgetBuilder`, we handle these differently:

```dart
// For static data, just read it
final label = datePickerData.label;

// For dynamic data, we SUBSCRIBE to it
final ValueNotifier<String?> notifier = context.dataContext
    .subscribeToString(datePickerData.value);

// And we can UPDATE it
final path = datePickerData.value?['path'] as String?;
// ... inside the widget ...
if (path != null) {
  context.dataContext.update(DataPath(path), newValue);
}
```

This pattern allows the `DateInputChip` to write its new value back to the shared `dataContext`. Other widgets (like the `Itinerary`) can listen to that same path and update automatically when the date changes!
