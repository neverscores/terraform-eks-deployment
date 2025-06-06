terraform {
    backend "s3" {
        bucket          = "hiive-state-backend"
        key             = "tf-infra/terraform.tfstate"
        region          = "us-east-1"
        dynamodb_table  = "hiive-terraform_state"
        encrypt         = true
    }
}
resource "aws_s3_bucket" "bucket" {
  bucket = "hiive-state-backend"
  
  # Required for Terraform state buckets
  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform-lock" {
  name         = "hiive-terraform_state"
  billing_mode = "PAY_PER_REQUEST"  
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform Lock Table"
  }
}