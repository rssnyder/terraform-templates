resource "minio_s3_bucket" "library" {
  bucket = "library"
  acl    = "private"

  lifecycle {
    ignore_changes = [
      acl
    ]
  }
}

resource "minio_s3_bucket" "youtube" {
  bucket = "youtube"
  acl    = "private"

  lifecycle {
    ignore_changes = [
      acl
    ]
  }
}

resource "minio_iam_policy" "librarian" {
  name   = "librarian"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutBucketPolicy",
        "s3:GetBucketPolicy",
        "s3:DeleteBucketPolicy",
        "s3:ListAllMyBuckets",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${minio_s3_bucket.library.bucket}",
        "arn:aws:s3:::${minio_s3_bucket.youtube.bucket}"
      ],
      "Sid": ""
    },
    {
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:ListMultipartUploadParts",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${minio_s3_bucket.library.bucket}/*",
        "arn:aws:s3:::${minio_s3_bucket.youtube.bucket}/*"
      ],
      "Sid": ""
    }
  ]
}
EOF
}

resource "minio_iam_user" "librarian" {
  name = "librarian"
}

resource "minio_iam_user_policy_attachment" "librarian" {
  user_name   = minio_iam_user.librarian.id
  policy_name = minio_iam_policy.librarian.id
}