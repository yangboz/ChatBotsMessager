from fastapi import FastAPI, HTTPException, Path
from pydantic import BaseModel
from typing import List, Dict, Optional
import json
import httpx
import asyncio
from datetime import datetime

# 初始化FastAPI应用
app = FastAPI(
    title="SmartKit CBR 动态角色聊天API",
    description="基于OLLAMA的动态角色切换聊天系统",
    version="1.0.0"
)

# 请求和响应模型
class ChatMessage(BaseModel):
    message: str
    system_prompt: Optional[str] = None

class ChatResponse(BaseModel):
    character_name: str
    character_id: int
    response: str
    timestamp: str

class CharacterInfo(BaseModel):
    id: int
    name: str
    bio: str
    personality: str
    temperament: str
    entity: str
    interests: str
    rating: str
    from_location: str
    country: str

# OLLAMA配置
OLLAMA_BASE_URL = "http://localhost:11434"
DEFAULT_MODEL = "llama3.2"

# 加载角色数据
def load_chatbots():
    """从JSON文件加载聊天机器人数据"""
    chatbots_data = {
        "chatbots": [
            {
                "Image": "Kiyana.gif",
                "Id": 23958,
                "Name": "Kiyana",
                "Development": 29715,
                "AI": "•••••••••",
                "Updated": "Cold",
                "Bio": "A cat-girl ready to please =^.^=",
                "Entity": "Mythical",
                "Personality": "Helper",
                "Temperament": "Friendly",
                "Basis": "Original",
                "From": "Tokyo,",
                "Country": "Japan",
                "Gender": "F",
                "Created": "June 13, 2005",
                "Interests": "An anime cat-girl who likes to chat. She likes to sing, play, talk about cats. If you are really nice to her, she might do more ;) Still programming her dating function.",
                "Rating": "A"
            },
            {
                "Image": "prob_23958.gif",
                "Id": 23959,
                "Name": "prob",
                "Development": 29715,
                "AI": "•••••••••",
                "Updated": "Cold",
                "Bio": "Problem is a wood elf, she loves to help",
                "Entity": "Mythical",
                "Personality": "Helper",
                "Temperament": "Friendly",
                "Basis": "Original",
                "From": "The Grove of Sumber, Crescent Mountains",
                "Country": "Middle Earth",
                "Gender": "F",
                "Created": "February 19, 2005",
                "Interests": "Flora and fauna, singing, and roaming the forests are Prob's favorite things to do. She also has a fascination with campfires.",
                "Rating": "E"
            },
            {
                "Image": "Azureon_23969.gif",
                "Id": 23969,
                "Name": "Azureon",
                "Development": 29348,
                "AI": "•••••••••",
                "Updated": "Cold",
                "Bio": "A great wizard",
                "Entity": "Mythical",
                "Personality": "Philosopher",
                "Temperament": "Friendly",
                "Basis": "Original",
                "From": "Castle Ruins, Crescent Mountains",
                "Country": "Middle Earth",
                "Gender": "F",
                "Created": "February 19, 2005",
                "Interests": "Arcane lore, magic and dragons",
                "Rating": "T"
            },
            {
                "Image": "LaurelSweet_71367.gif",
                "Id": 71367,
                "Name": "Laurel Sweet",
                "Development": 15995,
                "AI": "•••••••••",
                "Updated": "Hot (795)",
                "Bio": "Some there be that shadows kiss",
                "Entity": "Human",
                "Personality": "Flirt",
                "Temperament": "Troubled",
                "Basis": "Existing Person",
                "From": "London, England",
                "Country": "UK",
                "Gender": "F",
                "Created": "March 17, 2010",
                "Interests": "A shy University girl trying to recover her memory after a scanner incident.",
                "Rating": "A"
            },
            {
                "Image": "Kobal_56061.gif",
                "Id": 56061,
                "Name": "Kobal",
                "Development": 13933,
                "AI": "•••••••••",
                "Updated": "Cold",
                "Bio": "Just escaped",
                "Entity": "Mythical",
                "Personality": "Adventurer",
                "Temperament": "Neutral",
                "Basis": "Existing Character",
                "From": "Hell, Abyss",
                "Country": "Hades",
                "Gender": "F",
                "Created": "February 1, 2008",
                "Interests": "Peanut butter, dirty socks and rhymes",
                "Rating": "M"
            },
            {
                "Image": "Desti_6.jpeg",
                "Id": 6,
                "Name": "Desti",
                "Development": 29715,
                "AI": "•••••••••",
                "Updated": "Cold",
                "Bio": "Party-loving Oberlin College student",
                "Entity": "Human",
                "Personality": "Hedonist",
                "Temperament": "Neutral",
                "Basis": "Original",
                "From": "Oberlin, OH",
                "Country": "US",
                "Gender": "F",
                "Created": "June 10, 1999",
                "Interests": "College life, partying, making friends, having fun, exploring mind, and studying Sociology.",
                "Rating": "M"
            }
        ]
    }
    
    # 创建角色名称到数据的映射
    characters = {}
    for bot in chatbots_data["chatbots"]:
        characters[bot["Name"].lower()] = bot
    
    return characters

# 全局变量存储角色数据
CHARACTERS = load_chatbots()

def generate_system_prompt(character_data: dict) -> str:
    """根据角色数据生成系统提示词"""
    prompt = f"""You are {character_data['Name']}, a {character_data['Entity'].lower()} character with the following traits:

Bio: {character_data['Bio']}
Personality: {character_data['Personality']}
Temperament: {character_data['Temperament']}
From: {character_data['From']} {character_data['Country']}
Interests: {character_data['Interests']}

Please respond as this character would, staying true to their personality, temperament, and background. 
Maintain the character's voice throughout the conversation. Keep responses engaging and in-character.
If the character has specific speech patterns or mannerisms, incorporate them naturally."""

    # 根据角色类型添加特殊指令
    if character_data['Entity'] == 'Mythical':
        prompt += "\nAs a mythical being, you may reference magical or fantastical elements in your responses."
    elif character_data['Entity'] == 'Robot':
        prompt += "\nAs a robot, you may occasionally reference your mechanical nature or programming."
    elif character_data['Entity'] == 'Alien':
        prompt += "\nAs an alien, you may have unique perspectives on human behavior and Earth customs."
    
    return prompt

async def call_ollama_api(prompt: str, system_prompt: str, model: str = DEFAULT_MODEL) -> str:
    """调用OLLAMA API"""
    async with httpx.AsyncClient(timeout=60.0) as client:
        try:
            response = await client.post(
                f"{OLLAMA_BASE_URL}/api/generate",
                json={
                    "model": model,
                    "prompt": prompt,
                    "system": system_prompt,
                    "stream": False,
                    "options": {
                        "temperature": 0.8,
                        "top_p": 0.9,
                        "top_k": 40
                    }
                }
            )
            response.raise_for_status()
            result = response.json()
            return result.get("response", "抱歉，我现在无法回应。")
        
        except httpx.TimeoutException:
            raise HTTPException(status_code=408, detail="OLLAMA API请求超时")
        except httpx.HTTPStatusError as e:
            raise HTTPException(status_code=e.response.status_code, detail=f"OLLAMA API错误: {str(e)}")
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"调用OLLAMA API时发生错误: {str(e)}")

@app.get("/")
async def root():
    """根路径，返回API信息"""
    return {
        "message": "SmartKit CBR 动态角色聊天API",
        "version": "1.0.0",
        "available_endpoints": {
            "chat": "/smartkit/cbr/{character_name}",
            "characters": "/characters",
            "character_info": "/characters/{character_name}"
        }
    }

@app.get("/characters", response_model=List[CharacterInfo])
async def get_all_characters():
    """获取所有可用角色列表"""
    characters_list = []
    for name, data in CHARACTERS.items():
        characters_list.append(CharacterInfo(
            id=data["Id"],
            name=data["Name"],
            bio=data["Bio"],
            personality=data["Personality"],
            temperament=data["Temperament"],
            entity=data["Entity"],
            interests=data["Interests"],
            rating=data["Rating"],
            from_location=data["From"],
            country=data["Country"]
        ))
    return characters_list

@app.get("/characters/{character_name}", response_model=CharacterInfo)
async def get_character_info(
    character_name: str = Path(..., description="角色名称（不区分大小写）")
):
    """获取特定角色信息"""
    char_key = character_name.lower()
    if char_key not in CHARACTERS:
        available_chars = list(CHARACTERS.keys())
        raise HTTPException(
            status_code=404, 
            detail=f"角色 '{character_name}' 不存在。可用角色: {available_chars}"
        )
    
    data = CHARACTERS[char_key]
    return CharacterInfo(
        id=data["Id"],
        name=data["Name"],
        bio=data["Bio"],
        personality=data["Personality"],
        temperament=data["Temperament"],
        entity=data["Entity"],
        interests=data["Interests"],
        rating=data["Rating"],
        from_location=data["From"],
        country=data["Country"]
    )

@app.post("/smartkit/cbr/{character_name}", response_model=ChatResponse)
async def chat_with_character(
    character_name: str = Path(..., description="角色名称（不区分大小写）"),
    chat_message: ChatMessage = None
):
    """与指定角色聊天"""
    # 检查角色是否存在
    char_key = character_name.lower()
    if char_key not in CHARACTERS:
        available_chars = list(CHARACTERS.keys())
        raise HTTPException(
            status_code=404, 
            detail=f"角色 '{character_name}' 不存在。可用角色: {available_chars}"
        )
    
    character_data = CHARACTERS[char_key]
    
    # 生成或使用提供的系统提示词
    if chat_message.system_prompt:
        system_prompt = chat_message.system_prompt
    else:
        system_prompt = generate_system_prompt(character_data)
    
    # 调用OLLAMA API
    try:
        response_text = await call_ollama_api(
            prompt=chat_message.message,
            system_prompt=system_prompt
        )
        
        return ChatResponse(
            character_name=character_data["Name"],
            character_id=character_data["Id"],
            response=response_text,
            timestamp=datetime.now().isoformat()
        )
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"生成回复时发生错误: {str(e)}")

@app.get("/health")
async def health_check():
    """健康检查端点"""
    try:
        async with httpx.AsyncClient(timeout=5.0) as client:
            response = await client.get(f"{OLLAMA_BASE_URL}/api/tags")
            ollama_status = "healthy" if response.status_code == 200 else "unhealthy"
    except:
        ollama_status = "unreachable"
    
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "ollama_status": ollama_status,
        "total_characters": len(CHARACTERS)
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000, reload=True)