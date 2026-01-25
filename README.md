# Backend Infrastructure

## Bootstrap (one-time)

Before the first `terraform init/apply`, you need a one-time bootstrap to create
shared AWS primitives and the GitHub OIDC trust used by CI. You can do this
manually (AWS console/CLI) or via a dedicated `bootstrap/` Terraform stack.

### 1) Remote state and locking

Create the remote state S3 bucket and DynamoDB lock table that back the `envs/*`
state:

- **S3 bucket** for Terraform state (enable versioning and server-side
  encryption).
- **DynamoDB table** for state locks (partition key: `LockID` as a string).

Update your `envs/*/backend.tf` or backend config (`-backend-config`) with the
bucket name, key prefix, region, and lock table name after creation.

### 2) GitHub OIDC provider + IAM roles (both repos)

Set up the AWS IAM OIDC provider for GitHub Actions and create IAM roles that
trust it. Do this for **both repos** that deploy (e.g., the infrastructure repo
and the application/service repo). Each role should:

- Trust the GitHub OIDC provider (`token.actions.githubusercontent.com`) with
  conditions on `sub` (repo/environment) and `aud`.
- Allow the minimum set of permissions for Terraform plan/apply or deploy.

### 3) Subsequent deploys use OIDC (no static keys)

After bootstrap, CI should authenticate using OIDC and assume the IAM roles.
Do **not** store long-lived AWS access keys in secrets for routine deploys.

---

If you prefer Terraform for bootstrap, add a `bootstrap/` stack that manages the
S3 backend bucket, DynamoDB lock table, OIDC provider, and IAM roles, then run it
once per account/region.
