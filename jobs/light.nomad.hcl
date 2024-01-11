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
        source      = "https://www.haigmail.com/gitl/shellymgr.tar.gz"
        destination = "local/shelly/"
      }
      config {
        command = "local/shelly/shellymgr"
        args    = ["-turn", "${var.turn}", "-mode", var.mode, "-color", var.color]
      }
    }
  }
}