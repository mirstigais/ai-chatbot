# AI chatbot thingy for course
---
**Setup:**
1. Rename .env.example to .env (in case of changing the model, also swap it in ai-comply-modelfile)
2. Docker compose up. (might take a while)
3. Create knowledge base from rag-documents, use the EMBEDDING_MODEL from .env. (Yet to automate that) 
4. When chatting use ai-comply-chatbot.
5. To enable web search go "admin" -> "admin panel" -> "settings" -> "web search" -> set "web search engine" as searxng and rest should autofill, save the changes.
6. Custom prompts can be added though knowledge base. 

Proudly vibe configured with zero braincells used.

![alt text](img/AI_comp_image.png)


