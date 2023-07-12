resource "aws_s3_bucket" "onebucket" {
   bucket = "cumnewredcap"
   acl = "private"
   versioning {
      enabled = true
   }
   tags = {
     Name = "Bucket1"
     Environment = "Test"
   }
}