# Lesson 3.2: Creating a `CatalogItem`

Now let's look at how to define a single component. We'll use `lib/src/catalog/information_card.dart` as our example.

A `CatalogItem` has four main parts:

```dart
final informationCard = CatalogItem(
  name: 'InformationCard',
  dataSchema: _schema,
  exampleData: [ ... ],
  widgetBuilder: (context) { ... },
);
```

## 1. `name`
This is the unique identifier for the component. The AI uses this name to refer to the widget in its JSON response.
*   *Example*: `'InformationCard'`

## 2. `dataSchema`
This defines the structure of the data the AI needs to provide to configure this widget. It uses `json_schema_builder` (which we'll cover in Module 4).
*   *Example*: An object with `title`, `subtitle`, `body`, and `imageChildId`.

## 3. `exampleData`
This is crucial for "few-shot prompting." You provide examples of valid JSON data for this component. The GenUI framework automatically includes these examples in the prompt sent to the LLM, teaching it how to use your component correctly.

```dart
exampleData: [
  () => '''
    [
      {
        "id": "root",
        "component": {
          "InformationCard": {
            "title": { "literalString": "Beautiful Scenery" },
            "imageChildId": "image1"
            ...
          }
        }
      }
    ]
  ''',
],
```

## 4. `widgetBuilder`
This is where the magic happens. It's a function that takes the data provided by the AI (via `context.data`) and returns a standard Flutter `Widget`.

```dart
widgetBuilder: (context) {
  // 1. Parse the raw JSON data into a strongly-typed object
  final cardData = _InformationCardData.fromMap(
    context.data as Map<String, Object?>,
  );

  // 2. Resolve child widgets (if any)
  final Widget? imageChild = cardData.imageChildId != null
      ? context.buildChild(cardData.imageChildId!)
      : null;

  // 3. Subscribe to dynamic data updates
  final ValueNotifier<String?> titleNotifier = context.dataContext
      .subscribeToString(cardData.title);

  // 4. Return the actual Flutter widget
  return _InformationCard(
    imageChild: imageChild,
    titleNotifier: titleNotifier,
    ...
  );
},
```

### The `_InformationCard` Widget
Notice that `_InformationCard` is just a standard Flutter `StatelessWidget`. It doesn't know anything about AI or GenUI. It just takes `ValueNotifier`s and widgets as arguments. This separation of concerns is a best practice: keep your UI logic separate from your GenUI integration logic.
