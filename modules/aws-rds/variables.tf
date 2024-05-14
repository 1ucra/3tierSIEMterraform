variable "sg-name" {}
variable "db-subnet-name1" {}
variable "db-subnet-name2" {}
variable "db-sg-name" {}
variable "rds-username" {}
variable "rds-pwd" {}
variable "db-name" {}
variable "rds-name" {}
variable "db-instance-class" {}
variable "db-sg-id" {}
variable "db-user-id" {
  description = "Database user ID"
  type        = string
}

variable "db-user-pwd" {
  description = "Database user password"
  type        = string
  sensitive   = true
}