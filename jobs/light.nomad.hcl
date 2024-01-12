variable "url" {
  type        = string
  description = "Url of your light"
  default     = ""
}

variable "turn" {
  type        = string
  description = "Turn the light on or off"
  default     = ""
}

variable "mode" {
  type        = string
  description = "Change the light mode"
  default     = ""
}

variable "color" {
  type        = string
  description = "Pick a color R/G/Y"
  default     = ""
}

job "SetLight" {
  datacenters = ["tpi-dc1"]
  type        = "batch"
  group "shelly" {
    task "getshelly" {
      driver = "exec"
      artifact {
        source      = "https://github.com/lhaig/shellymgr/releases/download/v0.0.1/shellymgr-v0.0.1-linux-arm64.tar.gz"
        destination = "local/shelly/"
        options {
          checksum = "md5:89ad3b44cc1907383585811f7d55ee97"
        }
      }
      config {
        command = "local/shelly/shellymgr"
        args    = ["-url", "${var.url}", "-turn", "${var.turn}", "-mode", var.mode, "-color", var.color]
      }
    }
  }
}