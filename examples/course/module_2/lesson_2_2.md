# Lesson 2.2: Configuration

Before we can start generating UI, we need to configure our app to talk to an AI provider. The `travel_app` supports two backends: Google Generative AI (Gemini) and Firebase Vertex AI.

## 1. Choosing a Backend

In `lib/src/config/configuration.dart`, you will find an enum and a constant that control which backend is used:

```dart
enum AiBackend {
  firebase,
  googleGenerativeAi,
}

const AiBackend aiBackend = AiBackend.googleGenerativeAi;
```

For this course, we will primarily use `googleGenerativeAi` as it is easier to set up without creating a Firebase project.

## 2. Setting up Google Generative AI

To use the Google Generative AI backend, you need an API key.

1.  Get an API key from [Google AI Studio](https://aistudio.google.com/).
2.  The app expects this key to be available. In the `travel_app` example, there is logic in `lib/src/config/io_get_api_key.dart` (and the web equivalent) to retrieve this key.
    *   **On Mobile/Desktop**: It looks for an environment variable named `GOOGLE_AI_STUDIO_API_KEY`.
    *   **On Web**: It might look for a defined constant or user input.

**Best Practice**: Never commit your API keys to version control!

## 3. Initializing the GenUI Client

In `lib/src/travel_planner_page.dart`, the `TravelPlannerPage` initializes the `ContentGenerator` based on your configuration.

```dart
final ContentGenerator contentGenerator =
    widget.contentGenerator ??
    switch (aiBackend) {
      AiBackend.googleGenerativeAi => () {
        return GoogleGenerativeAiContentGenerator(
          catalog: travelAppCatalog,
          systemInstruction: prompt,
          additionalTools: [
            ListHotelsTool(
              onListHotels: BookingService.instance.listHotels,
            ),
          ],
          apiKey: getApiKey(),
        );
      }(),
      AiBackend.firebase => FirebaseAiContentGenerator(
        // ... Firebase configuration
      ),
    };
```

### Key Parameters:
-   **`catalog`**: The collection of widgets the AI can use (we'll build this in Module 3).
-   **`systemInstruction`**: The "prompt" that tells the AI how to behave (e.g., "You are a helpful travel agent...").
-   **`additionalTools`**: Functions the AI can call (e.g., `ListHotelsTool`).
-   **`apiKey`**: Your authentication key.

## 4. The `GenUiManager`

The `GenUiManager` is also initialized in the `initState` of `TravelPlannerPage`. It acts as the bridge between the AI's response and your Flutter widgets.

```dart
final genUiManager = GenUiManager(
  catalog: travelAppCatalog,
  configuration: const GenUiConfiguration(
    actions: ActionsConfig(
      allowCreate: true,
      allowUpdate: true,
      allowDelete: true,
    ),
  ),
);
```

This configuration tells the manager that the AI is allowed to create, update, and delete widgets in the conversation stream.
