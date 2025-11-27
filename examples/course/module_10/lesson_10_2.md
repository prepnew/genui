# Lesson 10.2: Designing the Catalog

To build this app, we need to define our "vocabulary" of widgets.

## 1. `QuestionCard`
Displays an interview question.

```dart
final questionCard = CatalogItem(
  name: 'QuestionCard',
  dataSchema: S.object(
    properties: {
      'question': S.string(description: 'The interview question.'),
      'difficulty': S.string(
        description: 'Difficulty level.',
        enumValues: ['Easy', 'Medium', 'Hard'],
      ),
      'category': S.string(description: 'Category (e.g., Technical, Behavioral).'),
    },
    required: ['question'],
  ),
  // ... widgetBuilder implementation
);
```

## 2. `FeedbackCard`
Displays feedback on the user's answer.

```dart
final feedbackCard = CatalogItem(
  name: 'FeedbackCard',
  dataSchema: S.object(
    properties: {
      'score': S.integer(description: 'Score from 1-10.'),
      'strengths': S.list(items: S.string(), description: 'What was good.'),
      'improvements': S.list(items: S.string(), description: 'What to improve.'),
      'suggestedAnswer': S.string(description: 'An example of a better answer.'),
    },
    required: ['score', 'strengths', 'improvements'],
  ),
  // ... widgetBuilder implementation
);
```

## 3. `ResumeHighlight`
Shows a specific section of the resume to provide context.

```dart
final resumeHighlight = CatalogItem(
  name: 'ResumeHighlight',
  dataSchema: S.object(
    properties: {
      'sectionTitle': S.string(description: 'Title of the section (e.g., "Experience").'),
      'content': S.string(description: 'The text content of that section.'),
      'annotation': S.string(description: 'Why this section is relevant to the current topic.'),
    },
    required: ['sectionTitle', 'content'],
  ),
  // ... widgetBuilder implementation
);
```
