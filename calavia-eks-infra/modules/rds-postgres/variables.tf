variable "db_name" {
  description = "The name of the PostgreSQL database."
  type        = string
}

variable "db_username" {
  description = "The username for the PostgreSQL database."
  type        = string
}

variable "db_password" {
  description = "The password for the PostgreSQL database."
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "The instance class for the PostgreSQL database."
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "The allocated storage for the PostgreSQL database in GB."
  type        = number
  default     = 20
}

variable "db_backup_retention" {
  description = "The number of days to retain backups."
  type        = number
  default     = 7
}

variable "vpc_security_group_ids" {
  description = "The VPC security group IDs to associate with the database."
  type        = list(string)
}

variable "subnet_ids" {
  description = "The subnet IDs where the database will be deployed."
  type        = list(string)
}