variable "db_user" {
  description = "User of database"
  default     = "appuser"
  type        = string
}

variable "db_name" {
  description = "Database name"
  default     = "appdb"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "external_port" {
  description = "External port"
  default     = 8080
  type        = number
}
