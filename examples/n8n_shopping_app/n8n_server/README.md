# n8n Backend for Shopping App

This folder contains an example n8n workflow to power the Shopping App.

## How to Use

1.  **Install n8n**:
    If you haven't already, install n8n (e.g., `npm install n8n -g` or use Docker).

2.  **Import Workflow**:
    -   Open your n8n dashboard (usually `http://localhost:5678`).
    -   Create a new workflow.
    -   Click the three dots in the top right -> "Import from File".
    -   Select `shopping_workflow.json`.

3.  **Activate Workflow**:
    -   Toggle the "Active" switch to ON.

4.  **Get Webhook URL**:
    -   Open the "Webhook" node.
    -   Click "Webhook URLs".
    -   Copy the "Test URL" (for testing) or "Production URL" (if active).
    -   It should look like: `http://localhost:5678/webhook/chat` (or `webhook-test/chat`).

5.  **Connect App**:
    -   Run the Flutter app.
    -   Paste this URL into the app's connection screen.

## How it Works

This example uses a **Code Node** to mock the AI's behavior. It checks if your prompt contains "headphones" or "shoes" and returns a pre-defined JSON response that the Flutter app understands.

### Real AI Integration
To make this "real":
1.  Replace the "Mock AI Agent" node with an **AI Agent** node.
2.  Connect it to an LLM Model (OpenAI, Anthropic, etc.).
3.  Give the Agent a tool (using the **Structured Output Parser** or similar) that outputs the `ProductCard` JSON schema.
4.  Ensure the final output of the workflow matches the JSON array format expected by the app.
