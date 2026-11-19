# defining the prod variables

variable "db_user" {
  description = "Database user"
  default     = "prod_db_user"
  type        = string
}

variable "db_name" {
  description = "Database name"
  default     = "prod-db"
  type        = string
}

variable "db_password" {
  description = "Database password"
  default     = "kshiwjb*&#0937bf3UQ++_93"
  type        = string
  sensitive   = true
}
