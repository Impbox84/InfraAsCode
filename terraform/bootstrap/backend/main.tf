resource "aws_s3_bucket" "states_bucket" {
    bucket = "infraascode-project-states-bucket"

    tags = {
        Name = "States Bucket"
    }
}

resource "aws_s3_bucket_versioning" "states_bucket_versioning" {
    bucket = aws_s3_bucket.states_bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}