# Introduction

Scripts to setup Azure IoT Gateway

## Prerequisites

1. Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

## Steps

```bash
export TF_VAR_HOSTNAME="10.3.141.1"
export TF_VAR_IOTEDGE_CONNECTION_STRING="<secret>"

terraform init -upgrade
terraform apply
```

This will generate files below in `generated` folder:

| File            | Usage                               |
| --------------- | ----------------------------------- |
| edge-ca.pem     | Public edge CA certificate          |
| edge-ca.key.pem | Private key of edge CA certificate  |
| config.toml     | IoT edge runtime configuration file |

# Copy files to IoT Edge device

```bash
hostname="<the hostname of gateway>"

scp -r ./generated $hostname:/tmp
ssh $hostname

sudo mkdir /var/secrets
sudo cp /tmp/generated/*.pem /var/secrets/
sudo cp /tmp/generated/config.toml /etc/aziot/

sudo iotedge config apply

# optionally display (and follow) system logs
sudo iotedge system logs -- -f

# optionally run a system check
sudo iotedge check

# optionally list running iotedge modules
sudo iotedge list

# if everything goes well you should see "edgeAgent" module running

# exit the SSH session
exit
```

## Connect downstream devices

Now follow [this article](https://docs.microsoft.com/en-us/azure/iot-edge/how-to-connect-downstream-device?view=iotedge-2020-11) to connect downstream devices. Downstream devices need to trust the generated edge CA certificate
