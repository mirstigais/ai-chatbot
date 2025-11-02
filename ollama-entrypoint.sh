#!/bin/bash

ollama serve &

OLLAMA_PID=$!

BASE_MODEL="${BASE_MODEL}"
EMBED_MODEL="${EMBEDDING_MODEL/ollama:}"
CHATBOT_MODEL="ai-comply-chatbot"

echo "Waiting for Ollama API to be ready..."
until /bin/ollama --version >/dev/null 2>&1; do
  sleep 1
done
echo "Ollama API is ready."

if ! ollama list | grep -q "$BASE_MODEL"; then
  echo "Base model ($BASE_MODEL) not found. Pulling model..."
  ollama pull "$BASE_MODEL"
else
  echo "Base model ($BASE_MODEL) already found in volume. Skipping pull."
fi

echo "Creating custom model: $CHATBOT_MODEL"
ollama create "$CHATBOT_MODEL" -f /tmp/ai-comply-modelfile

if ! ollama list | grep -q "$EMBED_MODEL"; then
  echo "Embedding model ($EMBED_MODEL) not found. Pulling..."
  ollama pull "$EMBED_MODEL"
else
  echo "Embedding model ($EMBED_MODEL) already found. Skipping pull."
fi

wait $OLLAMA_PID