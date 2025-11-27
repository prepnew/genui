# Lesson 7.1: Google Generative AI

The `genui_google_generative_ai` package provides the easiest way to get started with GenUI. It connects your app directly to Google's Gemini models.

## Configuration

As we saw in Module 2, configuring the service is straightforward:

```dart
GoogleGenerativeAiContentGenerator(
  catalog: travelAppCatalog,
  systemInstruction: prompt,
  additionalTools: [ ... ],
  apiKey: getApiKey(),
);
```

The `ContentGenerator` handles all the heavy lifting:
1.  It converts your `Catalog` into a format the LLM understands (JSON Schema).
2.  It manages the chat history.
3.  It parses the LLM's response, extracting text, tool calls, and UI definitions.

## Prompt Engineering for UI

The `systemInstruction` (or system prompt) is critical. It tells the AI *how* to use the UI components you've defined.

In `lib/src/travel_planner_page.dart`, look at the `prompt` variable. It contains detailed instructions:

### 1. Role Definition
```
You are a helpful travel agent assistant that communicates by creating and updating UI elements...
```

### 2. Conversation Flow
The prompt breaks down the interaction into steps:
*   **Inspiration**: Use `TravelCarousel` to suggest options.
*   **Destination Selection**: Show `InformationCard` and `Trailhead`.
*   **Itinerary Creation**: Use `InputGroup` for preferences, then `ItineraryWithDetails`.
*   **Booking**: Use `ListingsBooker`.

### 3. UI Rules
Explicit rules are often necessary to get high-quality results:
*   "Always prefer to communicate using UI elements rather than text."
*   "TravelCarousel: Always make sure there are at least four options."
*   "Inputs: ... It is a strict requirement that all input chip widgets bind their state to the data model."

### 4. Examples
Providing examples (One-Shot or Few-Shot prompting) is the most effective way to teach the model. The prompt includes a JSON example of a `surfaceUpdate` call.

**Pro Tip**: When defining your own catalog items, always include `exampleData` in the `CatalogItem` definition. The `ContentGenerator` automatically appends these examples to the system prompt!
