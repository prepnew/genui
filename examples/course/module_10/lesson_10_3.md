# Lesson 10.3: Implementation Guide

Here is the step-by-step plan to build your Interactive Resume.

## Step 1: Project Setup
1.  Create a new Flutter project: `flutter create interactive_resume`.
2.  Add dependencies: `genui`, `genui_google_generative_ai`, `json_schema_builder`.
3.  Get your Gemini API key.

## Step 2: Define the Catalog
1.  Create `lib/src/catalog/`.
2.  Implement `QuestionCard`, `FeedbackCard`, and `ResumeHighlight` (refer to Lesson 10.2).
3.  Create `lib/src/catalog.dart` and register your components.

## Step 3: Implement the Logic
1.  Create `lib/src/resume_manager.dart`.
    *   This class should hold the text content of your resume.
    *   *Tip*: For the MVP, just hardcode your resume as a String constant!
2.  Create `lib/src/tools/resume_tools.dart`.
    *   Implement a tool `getResumeContent()` that returns the resume text.
    *   Implement a tool `generateInterviewQuestions(topic)` that uses the resume to find relevant questions.

## Step 4: The Main Page
1.  Create `lib/src/interview_page.dart`.
2.  Initialize `GenUiManager` with your catalog.
3.  Initialize `GoogleGenerativeAiContentGenerator`.
    *   **System Prompt**: "You are an expert interview coach. You have access to the user's resume via tools. Your goal is to help them practice..."

## Step 5: Iterate and Polish
1.  Run the app.
2.  Ask: "Help me introduce myself."
3.  See if the AI uses the `Carousel` (if you added it) or text.
4.  Ask: "Interview me about my Flutter experience."
5.  Verify that `QuestionCard` appears.
6.  Answer the question.
7.  Verify that `FeedbackCard` appears.

## Bonus Challenges
*   **Voice Support**: Use `speech_to_text` to answer questions verbally.
*   **PDF Parsing**: Use a package to read real PDF files instead of hardcoded text.
*   **Persona Switching**: Add a settings menu to switch the interviewer persona (e.g., "Friendly Recruiter" vs. "Strict Hiring Manager").
