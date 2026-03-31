"""Test OpenAI API connection with new LLM client."""
import sys
import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

from src.llm import LLMClient, get_default_config

config = get_default_config("openai", "gpt-4o-mini")
print(f"Model: {config.model}")
print(f"Key: {config.resolved_api_key[:15]}...")
print(f"API URL: {config.api_url}")

client = LLMClient(config)

print("\nTesting API call...")
response = client.complete("Say exactly: TEST OK")

print(f"Success: {response.success}")
if response.success:
    print(f"Content: {response.content}")
    print("\n=== LLM IS WORKING ===")
else:
    print(f"Error: {response.error}")
