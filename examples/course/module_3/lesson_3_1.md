# Lesson 3.1: Understanding the `Catalog`

The **Catalog** is the dictionary of your GenUI application. It tells the AI exactly which UI components (widgets) are available for it to use. The AI cannot "hallucinate" new widgets; it is strictly bound by what you define in the catalog.

## What is a Catalog?

A `Catalog` is essentially a collection of `CatalogItem`s. Each item represents a specific widget (like a card, a carousel, or a button) and includes instructions on how to use it.

In the `travel_app`, the catalog is defined in `lib/src/catalog.dart`.

```dart
final Catalog travelAppCatalog = CoreCatalogItems.asCatalog()
    .copyWithout([
      // ... removing some default items we don't need
    ])
    .copyWith([
      CoreCatalogItems.imageFixedSize,
      checkboxFilterChipsInput,
      dateInputChip,
      informationCard,
      inputGroup,
      itinerary,
      listingsBooker,
      optionsFilterChipInput,
      tabbedSections,
      textInputChip,
      trailhead,
      travelCarousel,
    ]);
```

### Core vs. Custom Items

The `genui` package comes with a set of `CoreCatalogItems` (like `Column`, `Text`, `Row`, `Image`). You can use these out of the box.

However, the power of GenUI comes from defining **Custom Catalog Items** that are specific to your domain. In the `travel_app`, we have:
-   `informationCard`: A specialized card for showing destination details.
-   `itinerary`: A complex widget for showing a multi-day trip plan.
-   `listingsBooker`: A widget for selecting hotels.

By providing these high-level components, we make it much easier for the AI to construct complex UIs without having to build everything from primitive `Row`s and `Column`s.

## Registering Components

To make a component available to the AI, you simply add it to the list in the `.copyWith()` method when defining your catalog.

**Key Takeaway**: The Catalog acts as a contract between your Flutter code and the AI model.
