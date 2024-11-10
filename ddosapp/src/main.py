import os
from fastapi import FastAPI, Request, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from scalar_fastapi import get_scalar_api_reference
import google.generativeai as genai
import logging
import json
from collections import Counter
from dotenv import load_dotenv
load_dotenv()


from typing import Any

logger = logging.getLogger(__name__)

GEMINI_KEY=os.environ.get("GEMINI_KEY")
genai.configure(api_key=GEMINI_KEY)


def process_and_find_most_common_ip(text_input):
    # Remove the markers ```json and ``` from the beginning and end of the input
    cleaned_text = text_input.replace("```json", "").replace("```", "").strip()
    
    # Parse the cleaned text as JSON to get the list of IP addresses
    ip_list = json.loads(cleaned_text)
    
    # Count the occurrences of each IP address
    ip_counts = Counter(ip_list)
    
    # Find the IP address with the most occurrences
    most_common_ip, count = ip_counts.most_common(1)[0]
    
    return most_common_ip, count

app = FastAPI()


app.add_middleware(
    CORSMiddleware,
    allow_credentials=True,
    allow_methods=(
        "GET",
        "POST",
        "PUT",
        "PATCH",
        "DELETE",
        "OPTIONS",
    ),
)


@app.get("/healthcheck", include_in_schema=False)
async def healthcheck() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/attack-me")
async def attack_me(request: Request) -> dict[str, str]:
    logging.info(f"IP: {request.client.host}")  # pyright: ignore[reportOptionalMemberAccess]
    return {"reply": "yeyeye"}


@app.get("/scalar", include_in_schema=False)
async def scalar_html():
    return get_scalar_api_reference(
        openapi_url=str(app.openapi_url),
        title=app.title,
    )

@app.post("/process_log/")
async def process_log(file: UploadFile = File(...)):
    # Check if uploaded file is JSON
    if not file.filename.endswith(".json"):
        raise HTTPException(status_code=400, detail="File must be a JSON file")

    # Read the file contents
    try:
        contents = await file.read()
        json_data = json.loads(contents)
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Invalid JSON format: {e}")

    # Prepare the input for the GenAI model
    input_text = f"You're a security and threat evaluation analyst. Extract the IP addresses from the following JSON data:\n\n{json.dumps(json_data, indent=2)} return as json"

    try:
        # Generate content using the GenAI model
        model = genai.GenerativeModel("gemini-1.5-flash")
        response = model.generate_content(input_text)

        # Extract the generated text
        result = response.text
        most_common_ip, count = process_and_find_most_common_ip(text_input=result)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error processing the request: {e}")

    return {"ip": most_common_ip}
    # # Prepare the input text for the model, including the goal statement
    # input_text = f"{json_data}\n\nExtract the IP address in this log file and return it in a JSON response."

    # try:
    #     # Instantiate the model and generate content
    #     model = genai.GenerativeModel("gemini-1.5-flash")
    #     response = model.generate_content(input_text)
        
    #     # Extract the text from the response
    #     result = response.text
    # except Exception as e:
    #     raise HTTPException(status_code=500, detail=f"Error processing the request: {e}")

    # return {"extracted_data": result}