module "stack" {
  source          = "../../modules/stack"
  env_name        = "prod"
  external_port   = "8081"
  app_path        = abspath("${path.root}/../../app")
  nginx_conf_path = abspath("${path.root}/../../nginx/nginx.conf")
  db_name         = var.db_name
  db_password     = var.db_password
  db_user         = var.db_user
}
