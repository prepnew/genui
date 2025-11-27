# Lesson 4.1: Introduction to `json_schema_builder`

Large Language Models (LLMs) are very good at generating JSON, but they need to know the *structure* of the JSON they should generate. This is where JSON Schemas come in.

The `json_schema_builder` package allows you to define these schemas in Dart code, which are then automatically converted to the JSON Schema format that the AI understands.

## Defining Schemas

In `lib/src/catalog/information_card.dart`, we saw this schema definition:

```dart
final _schema = S.object(
  properties: {
    'imageChildId': S.string(
      description: 'The ID of the Image widget...',
    ),
    'title': A2uiSchemas.stringReference(
      description: 'The title of the card.',
    ),
    // ...
  },
  required: ['title', 'body'],
);
```

### Key Schema Types

1.  **`S.object`**: Defines a JSON object. You must list its `properties` and which ones are `required`.
2.  **`S.string`**: Defines a string field. Always provide a `description` to help the AI understand what this string is for.
3.  **`S.list`**: Defines an array. You must specify the schema for the `items` in the list.
4.  **`S.boolean`**, **`S.integer`**, **`S.number`**: For other primitive types.

## Why Descriptions Matter

Notice that every field has a `description`. **This is not just for documentation; it is part of the prompt sent to the AI.**

If you write:
```dart
'status': S.string(description: 'The status')
```
The AI might guess what "status" means.

But if you write:
```dart
'status': S.string(
  description: 'The booking status. Use "choiceRequired" when the user needs to select a hotel, and "chosen" when confirmed.',
  enumValues: ['choiceRequired', 'chosen', 'noBookingRequired'],
)
```
The AI now knows exactly how to use this field to control the application logic.
