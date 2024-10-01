from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from ibm_watsonx_ai.foundation_models import ModelInference
from pydantic import BaseModel
from ibm_watsonx_ai.foundation_models.utils.enums import DecodingMethods
from fastapi.responses import StreamingResponse
import asyncio
from ibm_watsonx_ai.metanames import GenTextParamsMetaNames as GenParams
from geopy.geocoders import Nominatim
from geopy.distance import geodesic
import json
from ibm_watsonx_ai import Credentials, APIClient


app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)
credentials = Credentials(
    api_key="",
    url="https://us-south.ml.cloud.ibm.com")

client = APIClient(credentials, project_id="")

# model_inference = ModelInference(
#     model_id="meta-llama/llama-3-4b-chat",
#     credentials={
#         "apikey": "qfdquM_AZ74d9vsvEx52RgQ8A3JQ5T-107wndG_Gj9WW",
#         "url": "https://us-south.ml.cloud.ibm.com"
#     },
#     project_id="9defbb65-08e4-4b1b-88b3-4b1d01ffda3e"
#     )
generate_params = {
    GenParams.MAX_NEW_TOKENS: 500,
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

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    try:
        while True:
            data = await websocket.receive_text()
            user_message = json.loads(data)["message"]

            prompt = f"""
You are a mental health support chatbot. A user has asked the following:
"{user_message}"
Please respond with relevant mental health resources and support services, particularly for Montreal, 
and provide emotionally supportive advice based on the user's concerns. 
Please only return Montreal resources if they ask for where to get Mental Health Support.
Please return Montreal specific communities if they ask for support groups or communities in Montreal.
If the user is happy, provide a positive response. Please add 5 !'s before your generated response.
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

@app.post("/resources")
async def get_resources(data: dict):
    print(data)
    latitude = data.get("latitude")
    longitude = data.get("longitude")

    if not latitude or not longitude:
        return {"error": "Latitude and longitude are required"}

    prompt = f"""Generate a JSON array of 5 mental health resources near the coordinates: {latitude}, {longitude}. Each resource should have the following properties: name, type, address, and phone. Ensure the output is a valid JSON array and nothing else. Do not include any additional text or formatting.

Example format:
[
  {
    "name": "Example Counseling Center",
    "type": "Therapy",
    "address": "123 Main St, City, State, ZIP",
    "phone": "(555) 123-4567"
  },
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
       
        #resources = parse_resources(response["results"][0]["generated_text"])
        generated_text = response["results"][0]["generated_text"]
        print("Generated text:", generated_text)
        try:
            start_index = generated_text.find('[')
            end_index = generated_text.rfind(']')
            if start_index != -1 and end_index != -1:
                resources_text = generated_text[start_index:end_index + 1]
                print("Extracted resources text:", resources_text)
                resources_json = json.loads(resources_text)
                print(resources_json)
                return {"resources": resources_json}
            else:
                print("No valid JSON array found in the generated text.")
                return {"error": "Invalid response format"}
        except (ValueError, json.JSONDecodeError) as e:
            print(f"Error parsing JSON: {str(e)}")
            return {"error": "Invalid response format"}
    except Exception as e:
        print(f"Error generating resources: {str(e)}")
        return {"error": "An error occurred while generating the resources"}
    
@app.websocket("/ws_meditation")
async def websocket_meditation_endpoint(websocket: WebSocket):
    await websocket.accept()
    try:
        while True:
            data = await websocket.receive_text()
            user_emotion = json.loads(data)["emotion"]

            prompt = f"Generate a short, calming 2-minute guided meditation for someone feeling {user_emotion}. The meditation should be soothing and help the user relax. Include breathing instructions and visualization techniques. Keep the language simple and easy to follow."

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

def parse_resources(text):
    try:
        # Remove any leading/trailing whitespace and parse the JSON
        print(text)
        resources_json = json.loads(text.strip())
        print(resources_json)
        
        # Process each resource in the list
        resources = []
        for resource in resources_json:
            processed_resource = {
                "name": resource.get("name", ""),
                "type": resource.get("typeOfService", ""),
                "description": resource.get("description", ""),
                "address": resource.get("address", ""),
                "phone": resource.get("phoneNumber", "")
            }
            resources.append(processed_resource)
        
        return resources
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON: {str(e)}")
        return []
    

