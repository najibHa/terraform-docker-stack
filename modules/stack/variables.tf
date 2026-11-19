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
  type        = number
}

variable "env_name" {
  description = "environment name"
  type        = string
}

variable "app_path" {
  description = "App path"
  type        = string
}

variable "nginx_conf_path" {
  description = "Path to the nginx configuration file"
  type        = string
}
