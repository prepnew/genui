# Lesson 3.3: Debugging with Catalog Gallery

As your catalog grows, testing each component within the full chat flow can become tedious. The **Catalog Gallery** pattern allows you to test your components in isolation.

## The `catalog_gallery` Example

The `genui` repository includes a `catalog_gallery` example. This is a developer tool that lets you browse your catalog and instantiate widgets with mock data.

### 1. `DebugCatalogView`

In `lib/main.dart` of the `catalog_gallery`, we see the `DebugCatalogView`:

```dart
DebugCatalogView(
  catalog: catalog,
  onSubmit: (message) {
    // Handle events triggered by the widget
    ScaffoldMessenger.of(context).showSnackBar(...);
  },
)
```

This widget automatically generates a UI that lists all items in your catalog. When you select an item (e.g., `InformationCard`), it:
1.  Shows the JSON schema for that item.
2.  Allows you to edit the JSON data directly.
3.  Renders the widget using that data.

This is invaluable for debugging layout issues or verifying that your widget handles edge cases (like missing images or long text) correctly, without needing to convince an AI to generate that specific state.

### 2. `SamplesView`

The `SamplesView` allows you to load pre-defined JSON samples from a directory.

```dart
SamplesView(
  samplesDir: widget.samplesDir!,
  catalog: catalog,
  fs: widget.fs,
)
```

You can save JSON files containing complex UI states (e.g., a full itinerary) and load them instantly. This serves as a suite of visual regression tests for your GenUI components.

## Best Practice

For any serious GenUI project, we recommend creating a "Gallery" app alongside your main app. It speeds up the development loop significantly.
