# defining the ressources

resource "docker_network" "stack" {
  name = "stack-net"
}
resource "docker_volume" "pgdata" {
  name = "stack-pgdata"
}


resource "docker_image" "pg_image" {
  name         = "postgres:16-alpine"
  keep_locally = true
}
resource "docker_image" "redis_image" {
  name         = "redis:7-alpine"
  keep_locally = true
}
resource "docker_image" "nginx_image" {
  name         = "nginx:1.27-alpine"
  keep_locally = true
}
resource "docker_image" "api_image" {
  name         = "stack-api:latest"
  keep_locally = true
  build {
    context = "${path.module}/app"
  }
}


resource "docker_container" "db" {
  name    = "db_container"
  image   = docker_image.pg_image.image_id
  restart = "unless-stopped"
  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}"
  ]
  volumes {
    volume_name    = "pg_volume"
    container_path = "/var/lib/postgresql/data"
  }
  networks_advanced {
    name    = docker_network.stack.name
    aliases = ["db"]
  }
  healthcheck {
    test         = ["CMD-SHELL", "pg_isready -U ${var.db_user} -d ${var.db_name}"]
    interval     = "5s"
    timeout      = "5s"
    retries      = 5
    start_period = "10s"
  }
  wait = true
}


resource "docker_container" "cache" {
  name    = "cache_container"
  image   = docker_image.redis_image.image_id
  restart = "unless-stopped"
  networks_advanced {
    name    = docker_network.stack.name
    aliases = ["cache"]
  }
  healthcheck {
    test         = ["CMD", "redis-cli", "ping"]
    interval     = "5s"
    timeout      = "5s"
    retries      = 5
    start_period = "10s"
  }
  wait = true
}


resource "docker_container" "api" {
  name       = "api_container"
  image      = docker_image.api_image.image_id
  restart    = "unless-stopped"
  depends_on = [docker_container.db, docker_container.cache]
  env = [
    "DB_HOST=db",
    "DB_USER=${var.db_user}",
    "DB_PASSWORD=${var.db_password}",
    "DB_NAME=${var.db_name}",
    "REDIS_HOST=cache"
  ]
  networks_advanced {
    name    = docker_network.stack.name
    aliases = ["api"]
  }
  healthcheck {
    test         = ["CMD-SHELL", "wget -q -O- http://localhost:3000/health"]
    interval     = "5s"
    timeout      = "5s"
    retries      = 5
    start_period = "10s"
  }
  wait = true
}


resource "docker_container" "nginx" {
  name       = "nginx_container"
  image      = docker_image.nginx_image.image_id
  restart    = "unless-stopped"
  depends_on = [docker_container.api]
  networks_advanced {
    name    = docker_network.stack.name
    aliases = ["nginx"]
  }
  volumes {
    host_path      = "${abspath(path.module)}/nginx/nginx.conf"
    container_path = "/etc/nginx/nginx.conf"
    read_only      = true
  }
  ports {
    internal = 80
    external = var.external_port
  }
}
