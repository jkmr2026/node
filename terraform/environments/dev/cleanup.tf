locals {
  cleanup_cluster_name = "${var.env_name}-eks-${var.name_suffix}"
  cleanup_log_group    = "/aws/eks/${local.cleanup_cluster_name}/cluster"
  cleanup_kms_alias    = "alias/eks/${local.cleanup_cluster_name}"
}

resource "null_resource" "cleanup_conflicts" {
  count = var.enable_conflict_cleanup ? 1 : 0

  triggers = {
    cluster_name = local.cleanup_cluster_name
    log_group    = local.cleanup_log_group
    kms_alias    = local.cleanup_kms_alias
    run_id       = timestamp()
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
      set -euo pipefail
      aws logs delete-log-group --log-group-name "${local.cleanup_log_group}" || true
      aws kms delete-alias --alias-name "${local.cleanup_kms_alias}" || true
    EOT
  }
}
