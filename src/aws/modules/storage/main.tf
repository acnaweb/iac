module "storage-public" {
    source  = "terraform-aws-modules/s3-bucket/aws"
    version = "4.2.2"
    create_bucket = "true"
    bucket = "${var.project_name}-public"

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false

    tags = {
        Name = "${var.project_name}-public"
        Purpose = "Bucket publico para acesso compartilhado"
    }
}

module "storage-raw" {
    source  = "terraform-aws-modules/s3-bucket/aws"
    version = "4.2.2"
    create_bucket = "true"
    bucket = "${var.project_name}-raw"

    # block_public_acls = true
    # block_public_policy = true
    # ignore_public_acls = false
    # restrict_public_buckets = true

    tags = {
        Name = "${var.project_name}-ras"
        Purpose = "Datalake - raw"
    }
}