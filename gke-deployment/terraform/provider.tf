provider "google" {
  project =  var.project-id
  region = var.region
  zone = var.zone
  credentials = file("api-sc.json")
}