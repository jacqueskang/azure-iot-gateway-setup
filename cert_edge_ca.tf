resource "tls_private_key" "edge_ca" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_sensitive_file" "private_key_edge_ca" {
  content  = tls_private_key.edge_ca.private_key_pem
  filename = "${path.module}/generated/edge-ca.key.pem"
}

resource "tls_cert_request" "edge_ca" {
  key_algorithm   = tls_private_key.edge_ca.algorithm
  private_key_pem = tls_private_key.edge_ca.private_key_pem

  subject {
    common_name  = "${var.HOSTNAME}.ca"
    organization = var.ORGANIZATION
  }
}

resource "tls_locally_signed_cert" "edge_ca" {
  cert_request_pem      = tls_cert_request.edge_ca.cert_request_pem
  ca_key_algorithm      = tls_private_key.root_ca.algorithm
  ca_private_key_pem    = tls_private_key.root_ca.private_key_pem
  ca_cert_pem           = tls_self_signed_cert.root_ca.cert_pem
  validity_period_hours = 86400 # 10 years
  is_ca_certificate     = true

  allowed_uses = [
    "cert_signing",
    "key_encipherment",
    "digital_signature"
  ]
}

resource "local_file" "cert_edge_ca" {
  content  = "${tls_locally_signed_cert.edge_ca.cert_pem}${tls_self_signed_cert.root_ca.cert_pem}"
  filename = "${path.module}/generated/edge-ca.pem"
}
