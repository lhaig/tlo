job "godad-webapp" {
  datacenters = ["tpi-dc1"]

  group "nginx" {
    count = 1
    network {
      mode = "bridge"
      port "http" {
        to = 80
      }
    }

    service {
      name     = "nginx-server"
      port     = "http"
      provider = "nomad"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.godad.entrypoints=web",
        "traefik.http.routers.godad.rule=PathPrefix(`/godad/`)",
        "traefik.http.middlewares.godad.stripprefix.prefixes=/godad"
      ]
      check {
        name     = "http_probe"
        type     = "http"
        path     = "/"
        interval = "5s"
        timeout  = "1s"
      }
    }

    task "server" {
      artifact {
        source      = "https://github.com/lhaig/godad/releases/download/v0.0.1/godad-v0.0.1-linux-arm64.tar.gz"
        destination = "local/godad/"
        options {
          checksum = "md5:3c5e8aa8222a6a67c2c710e12f75f2b6"
        }
      }

      action "godad" {
        command = "local/godad/godad"
        args    = [
          "-c ",
          "local/godad/godad | nomad var -force put nomad/jobs/godad-webapp godad=-"
        ]
      }

      driver = "docker"

      config {
        image = "nginx:latest"
        ports = ["http"]
        volumes = [
          "local/nginx:/usr/share/nginx/html",
        ]
      }

      template {
        destination = "local/nginx/godad/index.html"
        change_mode = "restart"
        data        = <<EOT
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Godad Joke</title>
</head>
<body>
  <h2>{{ with nomadVar "nomad/jobs/godad-webapp" }}{{ .godad }}{{ end }}</h2>
</body>
</html>

EOT
      }
    }
  }
}
