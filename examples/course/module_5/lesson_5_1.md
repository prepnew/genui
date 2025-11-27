# Lesson 5.1: Defining AI Tools

Sometimes, the AI needs to access real-world data or perform actions that it can't do on its own (like searching a database or booking a flight). In GenUI, we use **Tools** for this.

## The `AiTool` Class

To create a tool, you extend the `AiTool` class. Let's examine `lib/src/tools/booking/list_hotels_tool.dart`.

```dart
class ListHotelsTool extends AiTool<Map<String, Object?>> {
  ListHotelsTool({required this.onListHotels})
    : super(
        name: 'listHotels',
        description: 'Lists hotels based on the provided criteria.',
        parameters: S.object(
          properties: {
            'query': S.string(description: 'The search query...'),
            'checkIn': S.string(description: 'The check-in date...'),
            // ...
          },
          required: ['query', 'checkIn', 'checkOut', 'guests'],
        ),
      );

  final Future<HotelSearchResult> Function(HotelSearch search) onListHotels;

  @override
  Future<JsonMap> invoke(JsonMap args) async {
    final HotelSearch search = HotelSearch.fromJson(args);
    return (await onListHotels(search)).toAiInput();
  }
}
```

### Key Components

1.  **`name`**: The unique name the AI uses to call this tool.
2.  **`description`**: Explains to the AI *what* the tool does and *when* to use it.
3.  **`parameters`**: A JSON schema (using `json_schema_builder`) defining the arguments the tool expects.
4.  **`invoke`**: The method that actually executes the tool logic. It takes the arguments provided by the AI and returns a JSON result.

In this example, `invoke` calls a `BookingService` (which could be a real API call) and returns the list of hotels found.
