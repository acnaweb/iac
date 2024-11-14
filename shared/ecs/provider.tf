provider "aws" {
  region = "us-east-2"  
  shared_credentials_files = ["/shared/secrets/credentials"]
}