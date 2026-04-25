variable "TAG" {
  default = "latest"
}

group "default" {
  targets = ["phoenix"]
}

target "phoenix" {
  dockerfile = "Dockerfile"
  context = "."
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["tintinho/openclaw-phoenix:${TAG}"]
  output = ["type=registry"]
}
