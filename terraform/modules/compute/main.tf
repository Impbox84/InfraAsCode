resource "aws_instance" "app_server" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t3.micro"
    subnet_id = var.subnet_id
    iam_instance_profile = aws_iam_instance_profile.app_server_ssm_profile.name
    vpc_security_group_ids = [aws_security_group.app_server_security_group.id]

    tags = {
        Name = "learn-terraform"
    }
}

resource "aws_iam_role" "app_server_ssm_role" {
    name = "app_server_ssm_role"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_instance_profile" "app_server_ssm_profile" {
    name = "app_server_ssm_profile"
    role = aws_iam_role.app_server_ssm_role.name
}

resource "aws_iam_role_policy_attachment" "app_server_policy_attachment" {
    role = aws_iam_role.app_server_ssm_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_security_group" "app_server_security_group" {
    name = "app_server_security_group"
    description = "The app server security group"
    vpc_id = var.vpc_id

    tags = {
        Name = "app_server_security_group"
    }
}

resource "aws_vpc_security_group_egress_rule" "egress_allow_all" {
    security_group_id = aws_security_group.app_server_security_group.id

    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}