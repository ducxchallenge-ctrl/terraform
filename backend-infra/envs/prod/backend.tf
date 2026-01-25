terraform {
  backend "s3" {}
}

# Configure the backend with -backend-config or a backend config file
# to supply var.tf_state_bucket and var.tf_lock_table.
