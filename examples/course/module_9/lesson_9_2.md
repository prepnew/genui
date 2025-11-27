# Lesson 9.2: The Python Agent

In the `verdure` example, the server logic is written in Python. This allows us to define our schemas and tools using Python's type system.

## Defining Schemas (`a2ui_schema.py`)

Just like `json_schema_builder` in Dart, we define our UI components in Python.

```python
# server/verdure/a2ui_schema.py

class InformationCard(TypedDict):
    title: StringReference
    subtitle: NotRequired[StringReference]
    body: StringReference
    imageChildId: NotRequired[str]
```

These Python types are converted into JSON Schemas that the LLM understands.

## The Agent Logic (`agent.py`)

The agent is responsible for handling the conversation loop.

```python
# server/verdure/agent.py

async def run_agent(user_prompt: str, history: list[Message]):
    # 1. Construct the prompt with system instructions and history
    messages = build_prompt(user_prompt, history)

    # 2. Call the LLM (e.g., Gemini)
    response = await llm.generate_content(messages)

    # 3. Parse the response
    # The response might contain tool calls (to generate UI) or text.
    # We convert these into A2UI messages.
    return parse_response(response)
```

## Tools as UI Generators

In A2A, "generating UI" is just another tool the agent can call.

```python
# server/verdure/tools.py

@tool
def update_landscape(design: LandscapeDesign):
    """Updates the landscape design visualization."""
    return {
        "component": "LandscapeCanvas",
        "data": design
    }
```

When the agent calls `update_landscape`, the server sends a message to the client saying "Render the `LandscapeCanvas` component with this data."
