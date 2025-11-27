# Lesson 9.1: The A2A Architecture

The **Agent-to-Agent (A2A)** architecture represents the full-stack implementation of GenUI. Instead of your Flutter app talking directly to an LLM, it talks to a dedicated "Agent" running on a server.

## The `verdure` Example

The `verdure` example demonstrates this architecture. It consists of two parts:
1.  **Server (`server/verdure`)**: A Python application that defines the agent, its tools, and the UI schemas.
2.  **Client (`client`)**: A Flutter application that connects to the server.

## Why A2A?

### 1. Security
Your API keys and sensitive logic live on the server, not on the user's device.

### 2. State Persistence
The server can maintain the state of the conversation and the "world" (e.g., the landscape design in `verdure`) independently of the client. If the user closes the app and reopens it, the server remembers where they left off.

### 3. Complex Logic
Python has a rich ecosystem for AI and data processing (LangChain, NumPy, etc.). Running the agent in Python allows you to leverage these tools easily.

## The Protocol

The client and server communicate using the A2UI protocol over HTTP (or WebSockets).
1.  **Handshake**: The client connects and asks "What can you do?"
2.  **Agent Card**: The server responds with an "Agent Card" describing its capabilities.
3.  **Interaction**: The client sends user prompts; the server responds with A2UI messages to update the interface.
