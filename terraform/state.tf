terraform {
  backend "s3" {
    bucket = "tf-state-testapp"
    key    = "default.tfstate"
    region = "eu-west-1"
  }
}
