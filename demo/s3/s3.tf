resource "aws_s3_bucket" "s3" {
  bucket = "demo-s3-bucket"

  tags = {
    Name = "demo-s3-bucket"
  }
}