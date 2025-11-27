# Mastering Flutter GenUI: Building AI-Powered Interfaces
## Course Outline

This course is designed to take you from a beginner to an expert in building Generative UI applications using Flutter and the `genui` package. We will use the `travel_app` as our primary case study.

### Module 1: Introduction to Generative UI
*   **Lesson 1.1: What is Generative UI?**
    *   Concept: Moving beyond static widgets to AI-generated interfaces.
    *   The problem it solves: Dynamic, context-aware user experiences.
    *   Overview of the `genui` ecosystem.
*   **Lesson 1.2: The `travel_app` Case Study**
    *   Tour of the application features.
    *   Architecture overview.
    *   Running the example app.

### Module 2: Project Setup & Dependencies
*   **Lesson 2.1: `pubspec.yaml` Deep Dive**
    *   Core packages: `genui`, `genui_google_generative_ai`, `json_schema_builder`.
    *   Supporting packages: `gpt_markdown`, `intl`.
*   **Lesson 2.2: Configuration**
    *   Setting up API keys (Google AI, Firebase).
    *   Initializing the GenUI client.

### Module 3: The Catalog System (Defining Components)
*   **Lesson 3.1: Understanding the `Catalog`**
    *   What is a Catalog?
    *   Registering components.
    *   *Code Focus:* `lib/src/catalog.dart`
*   **Lesson 3.2: Creating a `CatalogItem`**
    *   Anatomy of a `CatalogItem`: `name`, `dataSchema`, `exampleData`, `widgetBuilder`.
    *   *Code Focus:* `lib/src/catalog/information_card.dart`
*   **Lesson 3.3: Debugging with Catalog Gallery**
    *   Testing components in isolation.
    *   Using `DebugCatalogView` and `SamplesView`.
    *   *Reference:* `catalog_gallery` example.

### Module 4: Schemas & Data Modeling
*   **Lesson 4.1: Introduction to `json_schema_builder`**
    *   Defining schemas with `S.object`, `S.string`, `S.list`.
    *   Why schemas are crucial for LLMs.
*   **Lesson 4.2: Static vs. Dynamic Data**
    *   `S.string` vs `A2uiSchemas.stringReference`.
    *   Handling user inputs and dynamic updates.
    *   *Code Focus:* `lib/src/catalog/information_card.dart` vs `lib/src/catalog/date_input_chip.dart`

### Module 5: AI Tools & Integration
*   **Lesson 5.1: Defining AI Tools**
    *   Creating tools for the LLM to use (e.g., searching hotels).
    *   `AiTool` class structure.
    *   *Code Focus:* `lib/src/tools/booking/list_hotels_tool.dart`
*   **Lesson 5.2: Connecting Tools to the UI**
    *   How the AI decides when to call a tool.
    *   Handling tool outputs in the UI.

### Module 6: Building the UI (Widgets & State)
*   **Lesson 6.1: The `GenUi` Widget**
    *   Integrating the chat interface.
    *   Handling messages and tool calls.
    *   *Code Focus:* `lib/src/travel_planner_page.dart`
*   **Lesson 6.2: Reactive Data Binding**
    *   Using `context.dataContext.subscribeToString`.
    *   Updating the UI when AI streams data.
*   **Lesson 6.3: Handling User Interactions**
    *   Dispatching events back to the AI.
    *   *Code Focus:* `lib/src/catalog/trailhead.dart`

### Module 7: Backend Integration
*   **Lesson 7.1: Google Generative AI**
    *   Configuring the `GoogleGenerativeAi` service.
    *   Prompt engineering for UI generation.
*   **Lesson 7.2: Firebase Integration (Optional)**
    *   Using `genui_firebase_ai` for backend-driven logic.
*   **Lesson 7.3: Custom Backend Implementation**
    *   Handling raw A2UI messages.
    *   Implementing custom `ContentGenerator` logic.
    *   *Reference:* `custom_backend` example.

### Module 8: Advanced Concepts
*   **Lesson 8.1: A2UI Protocol**
    *   Understanding the Agent-to-UI protocol.
    *   Server-driven UI updates.
*   **Lesson 8.2: Customizing the Experience**
    *   Theming and styling generated widgets.
    *   Best practices for prompt engineering in GenUI.

### Module 9: Full Stack GenUI (Agent-to-Agent)
*   **Lesson 9.1: The A2A Architecture**
    *   Client-Server model for GenUI.
    *   Python agents controlling Flutter clients.
    *   *Reference:* `verdure` example.
*   **Lesson 9.2: The Python Agent**
    *   Defining schemas and tools in Python.
    *   Handling prompts and state on the server.
*   **Lesson 9.3: The Flutter Client**
    *   Connecting to a remote A2A agent.
    *   Handling the handshake and message stream.
### Module 10: Capstone Project - The Interactive Resume
*   **Lesson 10.1: Project Overview & Requirements**
    *   Goal: Build an app to chat with your resume and practice interviews.
    *   Features: Self-introduction helper, Question generator, Answer feedback.
*   **Lesson 10.2: Designing the Catalog**
    *   Defining `QuestionCard`, `FeedbackCard`, and `ResumeHighlight`.
*   **Lesson 10.3: Implementation Guide**
    *   Step-by-step approach to building the app.
