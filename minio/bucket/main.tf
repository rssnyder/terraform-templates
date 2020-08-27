resource "minio_s3_bucket" "target" {
  bucket = var.name
  acl    = "private"
}

resource "minio_iam_policy" "target" {
  name   = var.name
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
        "arn:aws:s3:::${minio_s3_bucket.target.bucket}"
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
        "arn:aws:s3:::${minio_s3_bucket.target.bucket}/*"
      ],
      "Sid": ""
    }
  ]
}
EOF
}

resource "minio_iam_user" "target" {
  name = var.name
}

resource "minio_iam_user_policy_attachment" "target" {
  user_name   = minio_iam_user.target.id
  policy_name = minio_iam_policy.target.id
}