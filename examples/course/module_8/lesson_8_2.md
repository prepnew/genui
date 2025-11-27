# Lesson 8.2: Customizing the Experience

Building a GenUI app isn't just about wiring up the AI; it's about creating a delightful user experience.

## Theming and Styling

One of the best things about GenUI in Flutter is that **you control the rendering**. The AI sends data, but you decide how it looks.

In `lib/main.dart`, the app defines a standard Flutter theme:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
),
```

Your `CatalogItem` widgets (like `InformationCard`) are just normal Flutter widgets. They inherit this theme.

*   **Consistency**: Even though the UI is dynamic, it will always feel like *your* app because it uses your fonts, colors, and shapes.
*   **Dark Mode**: If you implement dark mode support in your widgets, the AI-generated UI will automatically support it too!

## Prompt Engineering Best Practices

The quality of your GenUI app depends heavily on your system prompt. Here are some tips from the `travel_app`:

1.  **Be Specific about UI Usage**: Don't just say "show results." Say "Use the `TravelCarousel` to show results."
2.  **Define a Persona**: "You are a helpful travel agent..." This helps the AI maintain a consistent tone.
3.  **Handle Edge Cases**: Tell the AI what to do if it finds no results or if the user asks for something out of scope.
4.  **Iterate**: Prompt engineering is an iterative process. Test your app, see where the AI fails, and update the prompt to fix it.

## Conclusion

Congratulations! You've completed the course. You now understand the core components of a GenUI application:
*   **Catalog**: The vocabulary of widgets.
*   **Schemas**: The grammar of data.
*   **Tools**: The connection to the real world.
*   **AI Backend**: The brain that orchestrates it all.

Now, go build something amazing!
