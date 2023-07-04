// Variables
variable "project_id" { type = string }
variable "env_name" { type = string }
variable "name" { type = string }
variable "location" { type = string }
variable "storage_class" { type = string }
variable "versioning" { type = bool }
variable "iam_members" { type = list(object({ role = string, member = string })) }
variable "bucket_policy_only" { type = bool }


// Resources

#  VMDK Buckets
module "cloud-storage-vmdk" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 3.3.0"

  project_id         = var.project_id
  name               = "tgrunt-${var.name}-${var.env_name}"
  location           = var.location
  storage_class      = var.storage_class
  versioning         = var.versioning
  log_bucket         = module.cloud-storage-logging.name
  iam_members        = var.iam_members
  bucket_policy_only = var.bucket_policy_only
}

resource "google_storage_bucket_iam_member" "public_access" {
  bucket = module.cloud-storage-vmdk.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

// Outputs

output "bucket_name" { value = module.cloud-storage-cdn.name }
