data "template_file" "aziot_config" {
  template = file("${path.module}/templates/config.template.toml")

  vars = {
    hostname          = var.HOSTNAME
    connection_string = var.IOTEDGE_CONNECTION_STRING
  }
}

resource "local_file" "aziot_config" {
  content  = data.template_file.aziot_config.rendered
  filename = "${path.module}/generated/config.toml"
}
