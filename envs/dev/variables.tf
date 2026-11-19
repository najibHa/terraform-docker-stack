# defining the dev variables

variable "db_user" {
  description = "Database user"
  default     = "dev_db_user"
  type        = string
}

variable "db_name" {
  description = "Database name"
  default     = "dev-db"
  type        = string
}

variable "db_password" {
  description = "Database password"
  default     = "kshiu^@*&8873UQ++_93"
  type        = string
  sensitive   = true
}
