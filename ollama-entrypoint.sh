#!/bin/bash

# 1. Start Ollama serve in the background (as before)
/bin/ollama serve &
OLLAMA_PID=$! # Store the process ID

# 2. Wait until Ollama API is available
echo "Waiting for Ollama API to be reachable using 'ollama --version'..."
until /bin/ollama --version >/dev/null 2>&1; do
  sleep 1
done
echo "Ollama service started and API is reachable."

# 3. Pull the main LLM (optional check, as create might pull it anyway)
if ! ollama list | grep -q "mistral:7b"; then
  echo "Mistral 7B not found. Pulling model..."
  ollama pull mistral:7b
else
  echo "Mistral 7B already found in volume. Skipping pull."
fi

# 4. Create the custom model
echo "Creating ai-comply-chatbot model..."
/bin/ollama create ai-comply-chatbot -f /tmp/ai-comply-modelfile

# 5. Pull the Embedding model for RAG
EMBED_MODEL="nomic-embed-text"
if ! /bin/ollama list | grep -q "$EMBED_MODEL"; then
  echo "Embedding model ($EMBED_MODEL) not found. Pulling..."
  /bin/ollama pull $EMBED_MODEL
else
  echo "Embedding model ($EMBED_MODEL) already found. Skipping pull."
fi

# 6. Kill the background server process
echo "Setup complete. Stopping background server."
kill $OLLAMA_PID

# 7. Start the main Ollama serve process (This becomes the container's primary process)
# Use 'exec' so that this is the final process and the container stays running.
echo "Starting final Ollama server process..."
exec /bin/ollama serve