Aerospike TLS Examples
================================================================================

This project contains complete functional examples of connecting to Aerospike
Server Enterprise with standard TLS or mutual authentication TLS (mTLS)
including:

* Scripts to general self-signed certificates for testing
* Configuration to run Aerospike Server locally in Docker
* Example application in Go, Java, and Python

### Prerequisites

* A *Feature Key File* (`features.conf`) for 
  [Aerospike Enterprise](https://www.aerospike.com/products/product-matrix/)
* [Docker](https://www.docker.com/) (verify with: `docker -v`)
* [OpenSSL](https://www.openssl.org/) (verify with: `openssl version`)


Quick Start
--------------------------------------------------------------------------------

### 1 - Generate Certificates

Execute `generate-certs.sh` to generate example self-signed TLS certificates:

```
$ ./generate-certs.sh
```

Output:
```
Creating 'certs' directory
Creating CA certificate
Generating a RSA private key
...................................................+++++
.....................+++++
writing new private key to 'certs/example.ca.key'
-----
Creating example.client ECDSA certificate
Signature ok
subject=CN = example.client, O = "Aerospike, Inc.", C = US
Getting CA Private Key
Creating example.server ECDSA certificate
Signature ok
subject=CN = example.server, O = "Aerospike, Inc.", C = US
Getting CA Private Key
Copying server certificate to aerospike server config directory
'certs/example.ca.crt' -> 'aerospike/etc/certs/example.ca.crt'
'certs/example.server.crt' -> 'aerospike/etc/certs/example.server.crt'
'certs/example.server.key' -> 'aerospike/etc/private/example.server.key'
---
certs
├── example.ca.crt
├── example.ca.key
├── example.client.crt
├── example.client.key
├── example.server.crt
└── example.server.key
aerospike/etc/certs/
├── example.ca.crt
└── example.server.crt
aerospike/etc/private/
└── example.server.key
```

### 2 - Install Feature Key File

Copy your `features.conf` file (provided by your Aerospike representative) to 
`aerospike/etc/features.conf`.

### 3a - Run Aerospike Server Enterprise (Standard TLS)

Run Aerospike Server configured for standard TLS:

```
$ docker run --rm --name aerospike-tls -p 4000:4000 -v \
$(pwd)/aerospike/etc:/opt/aerospike/etc aerospike/aerospike-server-enterprise \
--config-file /opt/aerospike/etc/aerospike-tls.conf
```

Confirm TLS connectivity using `asinfo` running locally in the container:

```
$ docker exec aerospike-tls asinfo -h 127.0.0.1:example.server:4000 --tls-enable \
--tls-cafile=/opt/aerospike/etc/certs/example.ca.crt -v 'status'
```

Output:
```
ok
```

### 3b - Run Aerospike Server Enterprise (Mutual TLS)

Run Aerospike Server configured for mutual TLS (mTLS):

```
$ docker run --rm --name aerospike-tls -p 4000:4000 -v \
$(pwd)/aerospike/etc:/opt/aerospike/etc aerospike/aerospike-server-enterprise \
--config-file /opt/aerospike/etc/aerospike-mtls.conf
```

Confirm mTLS connectivity using `asinfo` running locally in the container. Use
the server certificate as the client certificate:

```
$ docker exec aerospike-tls asinfo -h 127.0.0.1:example.server:4000 --tls-enable \
--tls-cafile=/opt/aerospike/etc/certs/example.ca.crt \
--tls-keyfile=/opt/aerospike/etc/private/example.server.key \
--tls-certfile=/opt/aerospike/etc/certs/example.server.crt -v 'status'
```

Output:
```
ok
```

### 4 - Run Example Application

Refer to the README for your preferred application language:

* [Java](tls-example-java/README.md)
* [Python](tls-example-python/README.md)
