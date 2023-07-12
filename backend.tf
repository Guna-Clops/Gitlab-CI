terraform {
  backend "s3" {
    bucket         = "terra-s3-bucket"   // replace with your bucketname
    dynamodb_table = "prod"   // create a Dynamo Db table and mention here
    key            = "dev/terraform.tfstate" // inside bucket create the file
    region         = "us-east-2"  
  }
}
