import os
import json
import logging
from collections import Counter
from typing import Any
from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from scalar_fastapi import get_scalar_api_reference
import google.generativeai as genai
from google.cloud import logging as gcp_logging
from dotenv import load_dotenv

# Load environment variables
load_dotenv('.env')

# Initialize logging
logger = logging.getLogger(__name__)

# Get Gemini API key and configure the API
GEMINI_KEY = os.environ.get("GEMINI_KEY")
genai.configure(api_key=GEMINI_KEY)

# Set up Google Cloud Logging client
gcp_logging_client = gcp_logging.Client()

# Initialize FastAPI app
app = FastAPI()

# Configure CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Replace "*" with specific origins in production for better security
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allow_headers=["*"],
)

def process_and_find_most_common_ip(text_input: str) -> tuple:
    """
    Process JSON-formatted text input to find and return the most common IP address.
    """
    # Remove formatting markers and parse as JSON
    cleaned_text = text_input.replace("```json", "").replace("```", "").strip()
    ip_list = json.loads(cleaned_text)
    
    # Count occurrences of each IP address
    ip_counts = Counter(ip_list)
    most_common_ip, count = ip_counts.most_common(1)[0]
    
    return most_common_ip, count

@app.get("/healthcheck", include_in_schema=False)
async def healthcheck() -> dict[str, str]:
    return {"status": "ok"}

@app.get("/attack-me")
async def attack_me(request: Request) -> dict[str, str]:
    logger.info(f"IP: {request.client.host}")
    return {"reply": "yeyeye"}

@app.get("/scalar", include_in_schema=False)
async def scalar_html():
    return get_scalar_api_reference(
        openapi_url=str(app.openapi_url),
        title=app.title,
    )

@app.get("/fetch_and_process_logs/")
async def fetch_and_process_logs():
    """
    Fetch recent GKE logs, extract IPs using Gemini API, and return the most common IP.
    """
    try:
        # Define a filter for GKE logs; customize based on your needs
        # log_filter = 'resource.type="k8s_container" AND severity="ERROR"'  # Modify this as per your log requirements
        log_filter = (
            'resource.type="k8s_container" AND '
            'severity="ERROR" AND '
            'labels."k8s-pod/app"="gemini-app"'
        )
        # Fetch logs from Google Cloud Logging
        entries = gcp_logging_client.list_entries(filter_=log_filter, page_size=20)
        log_data = [entry.payload for entry in entries]  # Assuming payload contains JSON data

        if not log_data:
            raise HTTPException(status_code=404, detail="No log data found matching the criteria")

        # Prepare input text for the Gemini API
        input_text = (
            "You're a security and threat evaluation analyst. "
            "Extract the IP addresses from the following JSON log data:\n\n"
            f"{json.dumps(log_data, indent=2)}\n\nReturn as JSON."
        )

        # Generate content using the Gemini API
        model = genai.GenerativeModel("gemini-1.5-flash")
        response = model.generate_content(input_text)
        result = response.text

        # Process the result to find the most common IP address
        most_common_ip, count = process_and_find_most_common_ip(result)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error processing logs: {e}")

    return {"most_common_ip": most_common_ip, "occurrences": count}
