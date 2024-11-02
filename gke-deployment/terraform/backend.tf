terraform {
  backend "gcs" {
    bucket = "gemini-api-infra-bucket"
    prefix = "terraform/state"
    # credentials = "api-sc.json"
  }
}

