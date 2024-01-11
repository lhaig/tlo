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
        source      = "https://www.haigmail.com/gitl/godadarm.tar.gz"
        destination = "local/godad/"
      }

      action "godad" {
        command = "local/godad/godadarm"
        args    = [
          "-c ",
          "local/godad/godadarm | nomad var -force put nomad/jobs/godad-webapp godad=-"
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
