resource "aws_s3_bucket" "states_bucket" {
    bucket = "infraascode-project-states-bucket"

    tags = {
        Name = "States Bucket"
    }
}

resource "aws_s3_bucket_versioning" "states_bucket_versioning" {
    bucket = aws_s3_bucket.states_bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_iam_openid_connect_provider" "github" {
    url = "https://token.actions.githubusercontent.com"
    client_id_list = ["sts.amazonaws.com"]
    thumbprint_list = ["d89e3bd43d5d909b47a18977aa9d5ce36cee184c"]
}

resource "aws_iam_role" "github_actions_role" {
    name = "GitHubActionsRole"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = { Federated = aws_iam_openid_connect_provider.github.arn }
            Action = "sts:AssumeRoleWithWebIdentity"
            Condition = {
                StringLike = {
                    "token.actions.githubusercontent.com:sub": "repo:Impbox84/InfraAsCode:*"
                }
            }
        }]
    })
}

resource "aws_iam_role_policy_attachment" "admin" {
    role = aws_iam_role.github_actions_role.name
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

output "github_role_arn" {
    value = aws_iam_role.github_actions_role.arn
}