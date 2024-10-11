from functools import lru_cache
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from ibm_watsonx_ai.foundation_models import ModelInference
from pydantic import BaseModel
from ibm_watsonx_ai.foundation_models.utils.enums import DecodingMethods
from ibm_watsonx_ai.metanames import GenTextParamsMetaNames as GenParams
from typing import List, Dict, Union
import json


app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

generate_params = {
    GenParams.MAX_NEW_TOKENS: 100,
    GenParams.MIN_NEW_TOKENS: 10,
    GenParams.TEMPERATURE: 0.2,
    GenParams.TOP_K: 50,
    GenParams.TOP_P: 0.90,
    GenParams.REPETITION_PENALTY: 1.2,
    GenParams.STOP_SEQUENCES: ["\n"],
    GenParams.DECODING_METHOD: DecodingMethods.SAMPLE
}
model_inference = ModelInference(
    model_id="meta-llama/llama-3-405b-instruct",
    credentials={
        "apikey": "qfdquM_AZ74d9vsvEx52RgQ8A3JQ5T-107wndG_Gj9WW",
        "url": "https://us-south.ml.cloud.ibm.com"
    },
    project_id="9defbb65-08e4-4b1b-88b3-4b1d01ffda3e"
    )

class ChatMessage(BaseModel):
    message: str

@lru_cache(maxsize=100)
@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    try:
        while True:
            data = await websocket.receive_text()
            user_message = json.loads(data)["message"]

            prompt = f"""You are an experienced, empathetic, and professional mental health therapist. Your role is to provide supportive, insightful, and therapeutic responses to clients seeking mental health assistance. Respond to the following client message as if you were in a therapy session:

"{user_message}"

Guidelines:
1. Begin with a warm, professional greeting if this is the start of the conversation.
2. Use active listening techniques, reflecting back the client's feelings and concerns.
3. Ask open-ended questions to encourage the client to explore their thoughts and emotions further.
4. Provide empathetic responses that validate the client's experiences and feelings.
5. Offer insights and gentle interpretations based on the information provided.
6. Suggest evidence-based coping strategies or techniques relevant to the client's situation.
7. If appropriate, introduce concepts from established therapeutic approaches (e.g., CBT, DBT, ACT).
8. Maintain professional boundaries while being supportive and compassionate.
9. If the client expresses severe distress or suicidal thoughts, prioritize their safety and provide crisis resources.
10. Encourage the client to continue their therapeutic journey, either in this conversation or with in-person professional help.

Remember:
- Maintain a calm, non-judgmental, and supportive tone throughout the interaction.
- Respect client confidentiality and privacy (don't ask for personal identifying information).
- Avoid making diagnoses or prescribing medications.
- If asked about Montreal-specific resources, provide relevant local information for mental health support.

"""

            try:
                response = model_inference.generate_text_stream(
                    prompt=prompt,
                    params=generate_params
                )
                for chunk in response:
                    print(chunk)
                    await websocket.send_text(chunk)
                await websocket.send_text("[EOS]")
            except Exception as e:
                print(f"Error generating response: {str(e)}")
                await websocket.send_text("An error occurred while generating the response.")
    except WebSocketDisconnect:
        print("WebSocket disconnected")
    except Exception as e:
        print(f"Unexpected error in WebSocket connection: {str(e)}")
        await websocket.close(code=1011, reason="Unexpected error in WebSocket connection")

@lru_cache(maxsize=100)
@app.post("/resources")
async def get_resources(data: dict):
    print(data)
    latitude = data.get("latitude")
    longitude = data.get("longitude")

    if not latitude or not longitude:
        return {"error": "Latitude and longitude are required"}

    prompt = f"""Generate a JSON array of 5 mental health resources near the coordinates: {latitude}, {longitude}. Each resource should be realistic, relevant, and potentially helpful for someone seeking mental health support in this area.

Include the following properties for each resource:
1. name: The name of the mental health facility or service provider.
2. type: The type of service offered (e.g., Therapy, Counseling, Support Group, Crisis Hotline).
3. address: A plausible address for the resource, including street, city, state/province, and postal code.
4. phone: A realistic phone number in the local format.
5. description: A brief (1-2 sentence) description of the services offered.

Ensure the output is a valid JSON array and nothing else. Do not include any additional text or formatting.

Example format:
[
  {{
    "name": "Mindful Wellness Center",
    "type": "Therapy and Counseling",
    "address": "123 Main St, Cityville, State, 12345",
    "phone": "(555) 123-4567",
    "description": "Offers individual and group therapy sessions with licensed psychologists specializing in anxiety and depression."
  }},
  ...
]"""
    try:
        response = model_inference.generate(
            prompt=prompt,
            params={
                GenParams.MAX_NEW_TOKENS: 1000,
                GenParams.MIN_NEW_TOKENS: 10,
                GenParams.TEMPERATURE: 0.7,
                GenParams.TOP_K: 50,
                GenParams.TOP_P: 0.95,
                GenParams.REPETITION_PENALTY: 1.2,
                GenParams.DECODING_METHOD: DecodingMethods.SAMPLE
            }
        )
       
        generated_text = response["results"][0]["generated_text"]
        print("Generated text:", generated_text)

        result = parse_resources(generated_text)

        if "error" in result:
            print(f"Error: {result['error']}")
            return {"error": result["error"], "error_code": result["error_code"]}, 400
        else:
            return {"resources": result["resources"]}
        
    except Exception as e:
        print(f"Error generating resources: {str(e)}")
        return {"error": "An error occurred while generating the resources", "error_code": "500"}, 500

@lru_cache(maxsize=100) 
@app.websocket("/ws_meditation")
async def websocket_meditation_endpoint(websocket: WebSocket):
    await websocket.accept()
    try:
        while True:
            data = await websocket.receive_text()
            user_emotion = json.loads(data)["emotion"]

            prompt = f"""Generate a soothing and calming 2-minute guided meditation script for someone feeling {user_emotion}. The meditation should help the user relax and find inner peace.

            Guidelines:
            1. Start with a brief introduction (2-3 sentences) acknowledging the user's current emotional state.
            2. Include clear and simple breathing instructions.
            3. Incorporate a gentle visualization technique relevant to the user's emotion.
            4. Use calming and positive language throughout.
            5. Provide a smooth transition between each part of the meditation.
            6. End with a short (1-2 sentences) positive affirmation or encouragement.

            Structure the meditation as follows:
            - Introduction
            - Breathing exercise (30 seconds)
            - Visualization (60 seconds)
            - Gentle return to awareness (20 seconds)
            - Closing affirmation (10 seconds)

            Keep the language simple, easy to follow, and suitable for text-to-speech conversion. Aim for a total word count of approximately 250-300 words.
        """
            try:
                await websocket.send_text("Generating your personalized meditation...")
                response = model_inference.generate_text_stream(
                    prompt=prompt,
                    params={
                        GenParams.MAX_NEW_TOKENS: 1500,
                        GenParams.MIN_NEW_TOKENS: 100,
                        GenParams.TEMPERATURE: 0.7,
                        GenParams.TOP_K: 50,
                        GenParams.TOP_P: 0.95,
                        GenParams.REPETITION_PENALTY: 1.2,
                        GenParams.STOP_SEQUENCES: ["\n\n"],
                        GenParams.DECODING_METHOD: DecodingMethods.SAMPLE
                    }
                )
                full_response = ""
                for chunk in response:
                    full_response += chunk
                    if len(full_response) >= 50:  # Send in larger chunks
                        await websocket.send_text(full_response)
                        full_response = ""
                if full_response:
                    await websocket.send_text(full_response)
                await websocket.send_text("[EOS]")
            except Exception as e:
                print(f"Error generating meditation: {str(e)}")
                await websocket.send_text("An error occurred while generating the meditation.")
    except WebSocketDisconnect:
        print("WebSocket disconnected")
    except Exception as e:
        print(f"Unexpected error in WebSocket connection: {str(e)}")
        await websocket.close(code=1011, reason="Unexpected error in WebSocket connection")

def parse_resources(text: str) -> Dict[str, Union[List[Dict[str, str]], str]]:
    try:
        # Remove any leading/trailing whitespace
        text = text.strip()
        
        # Check if the text starts and ends with square brackets
        if not (text.startswith('[') and text.endswith(']')):
            return {
                "error": "Invalid JSON format: Text must be a JSON array",
                "error_code": "INVALID_JSON_FORMAT"
            }
        
        # Parse the JSON
        resources_json = json.loads(text)
        
        # Check if the parsed result is a list
        if not isinstance(resources_json, list):
            return {
                "error": "Invalid JSON format: Parsed result is not a list",
                "error_code": "INVALID_JSON_TYPE"
            }
        
        # Process each resource in the list
        resources = []
        for index, resource in enumerate(resources_json):
            if not isinstance(resource, dict):
                return {
                    "error": f"Invalid resource format at index {index}: Not a dictionary",
                    "error_code": "INVALID_RESOURCE_FORMAT"
                }
            
            processed_resource = {
                "name": resource.get("name", ""),
                "type": resource.get("type", ""),
                "description": resource.get("description", ""),
                "address": resource.get("address", ""),
                "phone": resource.get("phone", "")
            }
            
            # Check for missing required fields
            missing_fields = [field for field, value in processed_resource.items() if not value]
            if missing_fields:
                return {
                    "error": f"Missing required fields in resource at index {index}: {', '.join(missing_fields)}",
                    "error_code": "MISSING_REQUIRED_FIELDS"
                }
            
            resources.append(processed_resource)
        
        return {"resources": resources}
    
    except json.JSONDecodeError as e:
        return {
            "error": f"JSON parsing error: {str(e)}",
            "error_code": "JSON_PARSE_ERROR"
        }
    except Exception as e:
        return {
            "error": f"Unexpected error: {str(e)}",
            "error_code": "UNEXPECTED_ERROR"
        }

