resource "tls_private_key" "edge_ca" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key_edge_ca" {
  content  = tls_private_key.edge_ca.private_key_pem
  filename = "${path.module}/generated/edge-ca.key.pem"
}

resource "tls_self_signed_cert" "main" {
  key_algorithm         = tls_private_key.edge_ca.algorithm
  private_key_pem       = tls_private_key.edge_ca.private_key_pem
  validity_period_hours = 87600 # 10 years
  is_ca_certificate     = true

  subject {
    common_name = var.HOSTNAME
  }

  allowed_uses = [
    "cert_signing",
    "key_encipherment",
    "digital_signature",
    "crl_signing"
  ]
}

resource "local_file" "cert_edge_ca" {
  content  = tls_self_signed_cert.main.cert_pem
  filename = "${path.module}/generated/edge-ca.pem"
}
