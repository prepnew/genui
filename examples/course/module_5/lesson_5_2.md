# Lesson 5.2: Connecting Tools to the UI

Defining a tool is only half the battle. We also need to register it and handle its output.

## Registering Tools

In `lib/src/travel_planner_page.dart`, we pass the tools to the `ContentGenerator`:

```dart
GoogleGenerativeAiContentGenerator(
  // ...
  additionalTools: [
    ListHotelsTool(
      onListHotels: BookingService.instance.listHotels,
    ),
  ],
);
```

This tells the AI model: "Hey, in addition to generating UI, you can also call this function `listHotels`."

## The Tool Execution Flow

1.  **User Prompt**: "Find me a hotel in Paris for next weekend."
2.  **AI Decision**: The AI analyzes the prompt and realizes it needs hotel data. It decides to call `listHotels` with arguments like `query: "Paris"`, `checkIn: "2025-06-01"`, etc.
3.  **Tool Execution**: The `GenUiManager` intercepts this call, executes the `invoke` method of `ListHotelsTool`, and gets the JSON result (a list of hotels).
4.  **AI Response**: The AI receives this JSON result. Now it has the data it needs!
5.  **UI Generation**: The AI generates a UI (e.g., a `TravelCarousel` or `ListingsBooker`) populated with the hotel data it just received.

## Handling Tool Outputs in UI

Crucially, the tool itself *does not* return UI. It returns *data*. It is up to the AI to decide how to present that data.

In the system prompt (`lib/src/travel_planner_page.dart`), we give the AI instructions on how to use this data:

```
When booking a hotel... use the `listHotels` tool to search for hotels and pass the values... to a `travelCarousel` to show the user different options.
```

This separation of **Data Retrieval** (Tools) and **Data Presentation** (UI Generation) is what makes GenUI so flexible.
