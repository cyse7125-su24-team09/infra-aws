# IAM Role for EKS Cluster Service
resource "aws_iam_role" "eks_cluster_service_role" {
  name = "${var.cluster_name}-eks-cluster-service-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "eks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_service_policy_attachment" {
  role       = aws_iam_role.eks_cluster_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


# IAM Role for EKS Node Group
resource "aws_iam_role" "eks_node_group_role" {
  name = "${var.cluster_name}-eks-node-group-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_group_policy_attachment" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy_attachment" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr_readonly_policy_attachment" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_policy" "fluentbit_policy" {
  name        = "${var.cluster_name}-fluentbit-policy"
  description = "IAM policy for Fluent Bit"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Action" : [
        "logs:CreateLogStream",
        "logs:CreateLogGroup",
        "logs:DescribeLogStreams",
        "logs:DescribeLogGroups",
        "logs:PutLogEvents",
        "logs:PutRetentionPolicy",
      ],
      "Resource" : "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "fluentbit_policy_attachment" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = aws_iam_policy.fluentbit_policy.arn
}

resource "aws_iam_policy" "external_dns_policy" {
  name        = "${var.cluster_name}-external-dns-policy"
  description = "IAM policy for ExternalDNS to manage Route 53 records"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ChangeResourceRecordSets"
        ],
        "Resource" : [
          "arn:aws:route53:::hostedzone/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:ListTagsForResource"
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "external_dns_policy_attachment" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = aws_iam_policy.external_dns_policy.arn
}