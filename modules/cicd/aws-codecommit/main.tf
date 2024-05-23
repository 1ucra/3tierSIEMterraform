resource "aws_codecommit_repository" "sourcecode-repository" {
  repository_name = var.repository_name
  description     = "My example CodeCommit repository"

  tags = {
    Name        = "My CodeCommit Repository"
    Environment = "Dev"
  }
}