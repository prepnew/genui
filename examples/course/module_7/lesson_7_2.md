# Lesson 7.2: Firebase Integration (Optional)

For production applications, you might want to use Firebase. The `genui_firebase_ai` package allows you to connect to Vertex AI through Firebase, which offers benefits like:

*   **Security**: You don't need to embed API keys in your app. You can use Firebase App Check to ensure only your app can access the API.
*   **Quotas & Billing**: Manage usage limits and billing through the Google Cloud Console.

## Setup Steps

1.  **Add Dependencies**:
    ```yaml
    dependencies:
      firebase_core: ...
      firebase_app_check: ...
      genui_firebase_ai: ...
    ```

2.  **Initialize Firebase**:
    In `lib/main.dart`, we initialize Firebase before running the app.

    ```dart
    if (aiBackend == AiBackend.firebase) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await FirebaseAppCheck.instance.activate(
        // ... configure providers for App Check
      );
    }
    ```

3.  **Use `FirebaseAiContentGenerator`**:
    Switch your configuration to use the Firebase generator.

    ```dart
    FirebaseAiContentGenerator(
      catalog: travelAppCatalog,
      systemInstruction: prompt,
      additionalTools: [ ... ],
      // No API key needed here! It uses the Firebase Auth context.
    );
    ```

## Vertex AI vs. Gemini API

Under the hood, both packages use Google's Gemini models. The difference is primarily in *how* you connect to them (direct API key vs. Firebase SDK).
