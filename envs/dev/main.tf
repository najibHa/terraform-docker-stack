module "stack" {
  source          = "../../modules/stack"
  env_name        = "dev"
  external_port   = "8080"
  app_path        = abspath("${path.root}/../../app")
  nginx_conf_path = abspath("${path.root}/../../nginx/nginx.conf")
  db_name         = var.db_name
  db_password     = var.db_password
  db_user         = var.db_user
}
