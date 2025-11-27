# Lesson 10.1: Project Overview & Requirements

For your capstone project, you will build an **Interactive Resume & Interview Coach**.

## The Problem
Static resumes are boring. Preparing for interviews is hard. What if your resume could talk? What if it could interview you?

## The Solution
An AI-powered Flutter application where:
1.  **The User** (you) uploads their resume (text or PDF content).
2.  **The AI** acts as an expert interviewer.
3.  **The UI** adapts to show relevant resume sections, flashcards for questions, and feedback scores.

## Key Features

### 1. "Tell me about yourself"
*   **User Goal**: Crafting the perfect elevator pitch.
*   **GenUI Feature**: The AI analyzes the resume and suggests 3 different "Introduction" styles (Professional, Creative, Concise) using a `Carousel` widget.

### 2. Interview Simulation
*   **User Goal**: Practice answering tough questions.
*   **GenUI Feature**: The AI generates a `QuestionCard`. When the user answers (via text or voice), the AI generates a `FeedbackCard` with a score and tips for improvement.

### 3. Resume Deep Dive
*   **User Goal**: Understanding what to highlight.
*   **GenUI Feature**: When discussing a specific job, the AI uses a `ResumeHighlight` widget to show that specific section of the resume with annotated improvements.

## Architecture

We will use the **Local-First** approach (like `travel_app`) for simplicity, but design our components to be A2UI-compliant so they could be moved to a server later.

*   **Backend**: `genui_google_generative_ai` (Gemini).
*   **State Management**: `GenUiManager` + `DataContext`.
*   **Catalog**: Custom widgets defined in `lib/src/catalog/`.
