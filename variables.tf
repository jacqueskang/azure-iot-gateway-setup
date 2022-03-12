variable "HOSTNAME" {
  description = "Hostname or private IP address of gateway"
  default     = "gateway"
}

variable "IOTEDGE_CONNECTION_STRING" {
  description = "Connection string of IoT Edge gateway"
  type        = string
  sensitive   = true
}
