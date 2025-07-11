import aiohttp
import asyncio

async def test_ollama_async():
    try:
        async with aiohttp.ClientSession() as session:
            url = "http://localhost:11434/api/generate"
            payload = {
                "model": "llama2",  # Replace with your model
                "prompt": "Hello, world!",
                "stream": False
            }
            
            async with session.post(url, json=payload) as response:
                print(f"Status code: {response.status}")
                
                if response.status == 200:
                    result = await response.json()
                    print(f"Response: {result}")
                    return True
                else:
                    error_text = await response.text()
                    print(f"Error: {error_text}")
                    return False
    except Exception as e:
        print(f"Exception: {e}")
        return False

# Run with: asyncio.run(test_ollama_async())