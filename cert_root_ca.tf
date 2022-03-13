resource "tls_private_key" "root_ca" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_sensitive_file" "private_key_root_ca" {
  content  = tls_private_key.root_ca.private_key_pem
  filename = "${path.module}/generated/root-ca.key.pem"
}

resource "tls_self_signed_cert" "root_ca" {
  key_algorithm         = tls_private_key.root_ca.algorithm
  private_key_pem       = tls_private_key.root_ca.private_key_pem
  validity_period_hours = 87600 # 10 years
  is_ca_certificate     = true

  subject {
    common_name         = "${var.ORGANIZATION} IoT Edge Root CA"
    organization        = var.ORGANIZATION
    organizational_unit = "Development"
    country             = "FRA"
    postal_code         = "92400"
  }

  allowed_uses = [
    "cert_signing",
    "key_encipherment",
    "digital_signature"
  ]
}

resource "local_file" "cert_root_ca" {
  content = tls_self_signed_cert.root_ca.cert_pem
  filename          = "${path.module}/generated/root-ca.pem"
}
