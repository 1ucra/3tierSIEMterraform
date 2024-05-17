resource "aws_codecommit_repository" "example" {
  repository_name = "my-repo"
  description     = "My example CodeCommit repository"

  tags = {
    Name        = "My CodeCommit Repository"
    Environment = "Dev"
  }
}