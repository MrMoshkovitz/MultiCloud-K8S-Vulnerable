

#*#################################################################################
#?                                      App1 - Vulny
#*#################################################################################

#?                                      App1 - Vulny
#*#################################################################################
#?                                      AWS EKS
#*#################################################################################

resource "aws_eks_cluster" "app1" {
    name = lower("${var.prefix}-eks-gm")
    role_arn = aws_iam_role.iam_for_eks.arn
    vpc_config {
        endpoint_private_access = true
        subnet_ids              = [aws_subnet.app1-db1.id, aws_subnet.app1-db2.id]
    }

    enabled_cluster_log_types = ["api", "audit"]



    depends_on = [
        aws_iam_role_policy_attachment.policy_attachement_eks1,
        aws_iam_role_policy_attachment.policy_attachement_eks2,
    ]    
}


resource "aws_eks_node_group" "app1" {
  cluster_name    = aws_eks_cluster.app1.name
  node_group_name = "nodegroup1"
  node_role_arn   = aws_iam_role.iam-high-priv-policy-assumerole-3.arn
  subnet_ids      = [aws_subnet.app1-db1.id, aws_subnet.app1-db2.id]

  scaling_config {
    desired_size = 1
    max_size     = 5
    min_size     = 1
  }

  update_config {
    max_unavailable = 3
  }
  
  depends_on = [
    aws_iam_role_policy_attachment.policy_attachement_eks_app1_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.policy_attachement_eks_app1_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.policy_attachement_eks_app1_AmazonEC2ContainerRegistryReadOnly,
  ]
}