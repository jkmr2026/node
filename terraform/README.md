# EKS cluster Terraform usage

## Layout
- [terraform/environments/dev/main.tf](../OneDrive/Desktop/node/terraform/environments/dev/main.tf:1) wires the AWS provider, VPC, subnets, and the EKS module.
- [terraform/environments/dev/cleanup.tf](../OneDrive/Desktop/node/terraform/environments/dev/cleanup.tf:1) optionally deletes a conflicting CloudWatch log group and KMS alias before apply.
- [terraform/environments/dev/terraform.tfvars](../OneDrive/Desktop/node/terraform/environments/dev/terraform.tfvars:1) defines region, CIDRs, node sizes, tags, and cleanup toggles for the dev workspace.
- [terraform/modules/eks_cluster/main.tf](../OneDrive/Desktop/node/terraform/modules/eks_cluster/main.tf:6) calls terraform-aws-modules/eks v20 with a minimal managed node group and KMS/log-group flags.

## Prerequisites
- Terraform >= 1.5.
- AWS CLI configured with credentials/profile for the target account (e.g., `AWS_PROFILE`).
- `kubectl` available for cluster access after creation.
- Bash available for the local-exec in [terraform/environments/dev/cleanup.tf](../OneDrive/Desktop/node/terraform/environments/dev/cleanup.tf:17) (Git Bash or WSL on Windows).

## Terraform workflow (dev)
From the repo root, run in [terraform/environments/dev](../OneDrive/Desktop/node/terraform/environments/dev):
```bash
cd terraform/environments/dev
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
# Destroy when finished
terraform destroy -var-file=terraform.tfvars
```
- Defaults in [terraform/environments/dev/terraform.tfvars](../OneDrive/Desktop/node/terraform/environments/dev/terraform.tfvars:1) produce cluster name `${var.env_name}-eks-${var.name_suffix}`; with current values the cluster is `dev-eks-new` per [terraform/environments/dev/main.tf](../OneDrive/Desktop/node/terraform/environments/dev/main.tf:21).
- To skip pre-flight log/KMS cleanup, set `enable_conflict_cleanup = false` in [terraform/environments/dev/terraform.tfvars](../OneDrive/Desktop/node/terraform/environments/dev/terraform.tfvars:25).

## OIDC / IRSA setup
- The EKS module enables IAM Roles for Service Accounts (IRSA) by default, creating the cluster OIDC provider during `terraform apply`. No extra inputs are required in [terraform/modules/eks_cluster/main.tf](../OneDrive/Desktop/node/terraform/modules/eks_cluster/main.tf:6).
- Verify the OIDC issuer and provider after apply:
  - Get issuer URL: `aws eks describe-cluster --name dev-eks-new --region ap-south-1 --query "cluster.identity.oidc.issuer" --output text`.
  - List IAM OIDC providers: `aws iam list-open-id-connect-providers --query 'OpenIDConnectProviderList[].Arn' --output text`.
- To create an IAM role for a Kubernetes service account (example):
  1) Note the issuer from the first command (e.g., `oidc.eks.ap-south-1.amazonaws.com/id/XXXX`).
  2) Create a trust policy that allows `sts:AssumeRoleWithWebIdentity` for subjects matching `system:serviceaccount:<namespace>:<serviceaccount>` and that OIDC provider ARN.
  3) Create the role and attach the needed IAM policy (replace placeholders):
  ```bash
  aws iam create-role \
    --role-name irsa-<namespace>-<sa> \
    --assume-role-policy-document file://trust.json
  aws iam attach-role-policy \
    --role-name irsa-<namespace>-<sa> \
    --policy-arn arn:aws:iam::<account_id>:policy/<policy_name>
  ```
  4) Annotate the service account so pods use the role:
  ```bash
  kubectl annotate serviceaccount <sa> \
    -n <namespace> \
    eks.amazonaws.com/role-arn=arn:aws:iam::<account_id>:role/irsa-<namespace>-<sa> \
    --overwrite
  ```
- Update your kubeconfig when the cluster is ready: `aws eks update-kubeconfig --name dev-eks-new --region ap-south-1 --alias dev-eks-new`.
