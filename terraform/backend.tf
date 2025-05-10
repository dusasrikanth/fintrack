terraform {
  backend "s3" {
    bucket = "fintrack-dev-backend"
    key    = "dev.statefile"
    region = "ap-south-1"
  }
}
