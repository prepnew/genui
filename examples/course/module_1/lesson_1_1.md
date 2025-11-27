# Lesson 1.1: What is Generative UI?

## The Shift from Static to Dynamic

Traditional UI development involves building static screens and widgets that are hardcoded to display specific data in a specific layout. While this works for many applications, it limits the flexibility of the user experience.

**Generative UI (GenUI)** represents a paradigm shift where the user interface is generated dynamically by an Artificial Intelligence (AI) model in response to user intent. Instead of navigating through a fixed tree of screens, the AI constructs the UI on the fly to best serve the user's current need.

### The Problem with Static UIs
In a traditional travel app, you might have:
1.  A search screen.
2.  A list of results.
3.  A details screen.
4.  A booking flow.

If a user asks, "Plan a romantic weekend in Paris with a focus on art," a traditional app forces them to search for flights, then hotels, then museums separately.

### The GenUI Solution
With GenUI, the AI understands the intent ("romantic weekend," "Paris," "art") and can generate a custom **Itinerary** widget that combines:
-   A romantic hotel recommendation.
-   Tickets to the Louvre and Musée d'Orsay.
-   A dinner reservation at a nice restaurant.

All of this is presented in a single, cohesive interface generated specifically for that request.

## The `genui` Ecosystem

The `genui` package provides the tools to build these experiences in Flutter. It consists of three main parts:

1.  **`genui` (Core)**: The fundamental classes for managing the UI generation process, including `GenUiManager`, `GenUiConversation`, and the `Catalog`.
2.  **`json_schema_builder`**: A helper package to define the *schema* of your UI components. This tells the AI what properties each widget has (e.g., an `InformationCard` has a `title`, `subtitle`, and `image`).
3.  **AI Backends**: Packages like `genui_google_generative_ai` or `genui_firebase_ai` that connect your Flutter app to an LLM (Large Language Model) which generates the UI definitions.

## Context: The `travel_app`
In the `travel_app` example we are exploring, you will see this in action. The app doesn't have a hardcoded "Itinerary Screen." Instead, it has an `Itinerary` component defined in its **Catalog**. When you ask the AI to plan a trip, it *chooses* to use the `Itinerary` component and populates it with data relevant to your request.
