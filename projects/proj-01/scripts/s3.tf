resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "static_website" {
  bucket = "terraform-course-project-1-${random_id.bucket_suffix.hex}"
}

resource "aws_s3_bucket_public_access_block" "static_website" {
  bucket                  = aws_s3_bucket.static_website.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "static_website_public_read" {
  bucket = aws_s3_bucket.static_website.id

  policy = jsonencode({
    Version = "2021-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static_website.arn}/*"
      }
    ]
  })

  # putting S3 Bucket (terraform-course-project-1-150cb7f2) Policy: operation error S3: PutBucketPolicy,
  # https response error StatusCode: 400, RequestID: HX526FD8WVY4DXMX, HostID: yZhZeOD+e995ChiajhAS6TlOImkau6sDRCSNhIIuigTeSqzx+ZJ/mHQ/k+Z3+a23shjk+10ZEo5t9Wwe7JfyKw==,
  # api error MalformedPolicy: The policy must contain a valid version string
  # -- to solve the above issue, we need to explicitly call depends_on to let the policy creation ok
  # -- then continue with the remain logic, this is mainly caused by trying to execute associated operations
  # -- upon S3 Objects by the required policy instance is still creating
  depends_on = [aws_s3_bucket.static_website, aws_s3_bucket_public_access_block.static_website]
}

resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }


  error_document {
    key = "error.html"
  }
}


resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.static_website.id
  key          = "index.html"
  source       = "build/index.html"
  etag         = filemd5("build/index.html")
  content_type = "text/html"
}

resource "aws_s3_object" "error_html" {
  bucket       = aws_s3_bucket.static_website.id
  key          = "error.html"
  source       = "build/error.html"
  etag         = filemd5("build/error.html")
  content_type = "text/html"
}