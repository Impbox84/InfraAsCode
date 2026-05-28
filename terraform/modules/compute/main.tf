locals {
    k3s_token = "mon-token-super-secret-et-unique"
}

resource "aws_instance" "k3s_master" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.small"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.k3s_nodes_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.k3s_nodes_ssm_profile.name

  user_data = templatefile("${path.module}/scripts/master.sh", {})
  
  tags = { Name = "k3s-master" }
}

resource "aws_instance" "k3s_worker" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.small"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.k3s_nodes_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.k3s_nodes_ssm_profile.name

  user_data = templatefile("${path.module}/scripts/worker.sh", { 
    master_ip = aws_instance.k3s_master.private_ip,
    token     = local.k3s_token 
  })

  tags = { Name = "k3s-worker" }
}

resource "aws_iam_role" "k3s_nodes_ssm_role" {
    name = "k3s_nodes_ssm_role"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_instance_profile" "k3s_nodes_ssm_profile" {
    name = "k3s_nodes_ssm_profile"
    role = aws_iam_role.k3s_nodes_ssm_role.name
}

resource "aws_iam_role_policy_attachment" "k3s_nodes_policy_attachment" {
    role = aws_iam_role.k3s_nodes_ssm_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_security_group" "k3s_nodes_security_group" {
    name = "k3s_nodes_security_group"
    description = "The k3s nodes security group"
    vpc_id = var.vpc_id

    tags = {
        Name = "k3s_nodes_security_group"
    }
}

resource "aws_vpc_security_group_egress_rule" "egress_allow_all" {
    security_group_id = aws_security_group.k3s_nodes_security_group.id

    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "allow_cluster_traffic" {
    security_group_id = aws_security_group.k3s_nodes_security_group.id
    referenced_security_group_id = aws_security_group.k3s_nodes_security_group.id
    ip_protocol = "-1"
}