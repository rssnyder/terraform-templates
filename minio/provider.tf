provider "minio" {
  minio_server     = "192.168.0.4:9768"
  minio_region     = "us-east-1"
  minio_access_key = "key"
  minio_secret_key = "secret"
  version          = "1.0"
}
