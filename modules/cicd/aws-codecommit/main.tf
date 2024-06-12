resource "aws_codecommit_repository" "sourcecode-repository" {
  repository_name = var.repository_name
  description     = "My example CodeCommit repository"

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_codecommit_repository/sourcecode-repository"
    owner = "ktd-admin"
  }
}