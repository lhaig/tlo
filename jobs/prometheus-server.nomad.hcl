job "prometheus-server" {
  datacenters = ["tpi-dc1"]
  type        = "service"
  group "server" {
    network {
      mode = "bridge"
      port "prometheus" {
        to = 9090
      }
    }

    service {
      name     = "prometheus-server"
      port     = "prometheus"
      provider = "nomad"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.prometheus.entrypoints=web",
        "traefik.http.routers.prometheus.rule=PathPrefix(`/prometheus/`)",
      ]

      check {
        name     = "prometheus_http_probe"
        type     = "http"
        path     = "/prometheus/-/healthy"
        interval = "5s"
        timeout  = "1s"
      }
    }

    task "server" {
      driver = "docker"
      config {
        image = "prom/prometheus:v2.45.2"
        ports = ["prometheus"]
        args = [
          "--config.file=${NOMAD_TASK_DIR}/config/prometheus.yml",
          "--storage.tsdb.path=/prometheus",
          "--web.listen-address=0.0.0.0:9090",
          "--web.console.libraries=/usr/share/prometheus/console_libraries",
          "--web.console.templates=/usr/share/prometheus/consoles",
          "--web.external-url=/prometheus/",
        ]

        volumes = [
          "local/config:/etc/prometheus/config",
        ]
      }

      template {
        data = <<EOH
---
global:
  scrape_interval:     1s
  evaluation_interval: 1s

scrape_configs:
  - job_name: "prometheus_server"
    metrics_path: "/prometheus/metrics"
    static_configs:
      - targets:
        - 0.0.0.0:9090

  - job_name: "nomad_server"
    metrics_path: "/v1/metrics"
    scheme: "http"
    params:
      format:
        - "prometheus"
    static_configs:
      - targets:
        - 192.168.1.100:4646
        - 192.168.1.101:4646
        - 192.168.1.102:4646

  - job_name: "nomad_client"
    metrics_path: "/v1/metrics"
    scheme: "http"
    params:
      format:
        - "prometheus"
    static_configs:
      - targets:
        - 192.168.1.104:4646
        - 192.168.1.105:4646
        - 192.168.1.106:4646
        - 192.168.1.107:4646

  - job_name: "prometheus_node_exporter"
    metrics_path: "/metrics"
    static_configs:
      - targets:
        {{- range nomadService "prometheus-node-exporter" }}
        - {{ .Address }}:{{ .Port }}{{- end }}

EOH

        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/prometheus.yml"
      }

      resources {
        cpu    = 500
        memory = 512
      }
    }
  }
}
