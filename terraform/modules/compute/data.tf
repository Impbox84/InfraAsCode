data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
    }

    owners = ["099720109477"]
}

data "aws_iam_policy_document" "assume_role" {
    statement {
        effect = "Allow"

        principals {
            type = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }

        actions = ["sts:AssumeRole"]
    }
}