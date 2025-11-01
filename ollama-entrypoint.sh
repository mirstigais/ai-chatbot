#!/bin/bash

# Start the Ollama service in the background
/bin/ollama serve &

# Wait a moment for the server to start
sleep 5

# Check if the model is already downloaded using `ollama list`
# If mistral:7b is not in the list, then pull it.
if ! ollama list | grep -q "mistral:7b"; then
  echo "Mistral 7B not found. Pulling model..."
  ollama pull mistral:7b
else
  echo "Mistral 7B already found in volume. Skipping pull."
fi

# The main Ollama process is still running in the background.
# This prevents the container from exiting.

# Do the magic with the modelfile
/bin/ollama create ai-comply-chatbot -f /tmp/ai-comply-modelfile
wait $!