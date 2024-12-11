module "storage-default" {
    source  = "terraform-aws-modules/s3-bucket/aws"
    version = "4.2.2"
    create_bucket = "true"
    bucket = "marketmining-public"


    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
    

    # lifecycle_rule = [{
    #     lifecycle = {
    #         ignore_changes = [tags]
    #         }
    #     }        
    # ]

    tags = {
        Name = "marketmining-public"
        Purpose = "Bucket publico para acesso compartilhado"
    }
}