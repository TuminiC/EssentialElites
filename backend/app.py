from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from ibm_watsonx_ai.foundation_models import ModelInference
from pydantic import BaseModel
from ibm_watsonx_ai.foundation_models.utils.enums import DecodingMethods
from fastapi.responses import StreamingResponse
import asyncio
from ibm_watsonx_ai.metanames import GenTextParamsMetaNames as GenParams
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
    api_key="Rd0fBoSeWEwy5EH00xYmPtqYVUKL49HirtXv38V9astL",
    url="https://us-south.ml.cloud.ibm.com")

client = APIClient(credentials, project_id="34546867-0bf7-4cf5-83aa-c71fb3dcb12b")

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
    # model_id=ModelTypes.LLAMA_2_13B_CHAT,
    model_id=client.foundation_models.TextModels.LLAMA_3_405B_INSTRUCT,
    params=generate_params,
    credentials=credentials,
    project_id="34546867-0bf7-4cf5-83aa-c71fb3dcb12b"
)

class ChatMessage(BaseModel):
    message: str
# @app.post('/chat')
# def chat(chat_message: ChatMessage):

#     user_message = chat_message.message
#     if not user_message:
#         raise HTTPException(status_code=400, detail="No message provided")
    
#     prompt = f"As a mental health professional, respond to: {user_message}\nResponse:"
    
#     response = model_inference.generate_text_stream(
#         prompt=prompt,
#         params={
#             GenParams.MAX_NEW_TOKENS: 100,
#             GenParams.MIN_NEW_TOKENS: 10,
#             GenParams.TEMPERATURE: 0.7,
#             GenParams.TOP_K: 50,
#             GenParams.TOP_P: 0.95,
#             GenParams.REPETITION_PENALTY: 1.2,
#             GenParams.STOP_SEQUENCES: ["\n"],
#             GenParams.DECODING_METHOD: DecodingMethods.SAMPLE
#         }
#     )
#     for chunk in response:
#         print(chunk, end='', flush=True)
    
#     # ai_response = response.get("generated_text")
#     return {"message": response}
        
    #     if not ai_response:
    #         ai_response = "I apologize, but I couldn't generate a response. Please try again."
        
    #     responses[chat_id] = ChatResponse(id=chat_id, status="completed", response=ai_response)
    # except Exception as e:
    #     print(f"Error generating response: {str(e)}")
    #     #responses[chat_id] = ChatResponse(id=chat_id, status="error", response="An error occurred while generating the response.")



# async def generate_response_stream(user_message: str):
#     prompt = f"As a mental health professional, respond to: {user_message}\nResponse:"

#     try:
#         response = model_inference.generate_text_stream(
#             prompt=prompt,
#             params={
#                 GenParams.MAX_NEW_TOKENS: 150,
#                 GenParams.MIN_NEW_TOKENS: 10,
#                 GenParams.TEMPERATURE: 0.7,
#                 GenParams.TOP_K: 50,
#                 GenParams.TOP_P: 0.95,
#                 GenParams.REPETITION_PENALTY: 1.2,
#                 GenParams.STOP_SEQUENCES: ["\n"],
#                 GenParams.DECODING_METHOD: DecodingMethods.SAMPLE
#             }
#         )
#         for chunk in response:
#             yield f"data: {chunk}\n\n"
#             await asyncio.sleep(0.1)  # Small delay to control the stream rate
#     except Exception as e:
#         print(f"Error generating response: {str(e)}")
#         yield f"data: An error occurred while generating the response.\n\n"

# @app.post("/chat")
# async def chat(chat_message: ChatMessage):
#     if not chat_message.message:
#         raise HTTPException(status_code=400, detail="No message provided")

#     return StreamingResponse(generate_response_stream(chat_message.message), media_type="text/event-stream")


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
                    await websocket.send_text(chunk)
                await websocket.send_text("[EOS]")
            except Exception as e:
                print(f"Error generating response: {str(e)}")
                await websocket.send_text("An error occurred while generating the response.")
    except WebSocketDisconnect:
        print("WebSocket disconnected")
