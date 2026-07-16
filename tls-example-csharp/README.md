Aerospike TLS Example in C#
================================================================================

Example C# application demonstrating how to connect to Aerospike Server
Enterprise with standard TLS or mutual authentication TLS (mTLS).

Before running `./install-certs.sh` in this directory (`tls-example-csharp`),
run `./generate-certs.sh` from the root of the
[aerospike-tls-examples](https://github.com/aerospike-examples/aerospike-tls-examples)
repository. `install-certs.sh` looks for generated certificates in `../certs`
when `tls-example-csharp` is inside the `aerospike-tls-examples` tree, or in
`../aerospike-tls-examples/certs` when `tls-example-csharp` is cloned as a
sibling of `aerospike-tls-examples`. Set `CERT_DIR` to point elsewhere if
needed.

### Prerequisites

* [.NET SDK 8.0 or later](https://dotnet.microsoft.com/download) (verify with: `dotnet --version`)
* OpenSSL (verify with: `openssl version`)
* Aerospike Server Enterprise with TLS configured in Docker (see [main README](https://github.com/aerospike-examples/aerospike-tls-examples/blob/master/README.md))

Quick Start
--------------------------------------------------------------------------------

### 1 - Run Aerospike Server Enterprise

Follow the __Quick Start__ steps in the
[main README](https://github.com/aerospike-examples/aerospike-tls-examples/blob/master/README.md)
to set up Aerospike Server Enterprise in Docker with TLS. The single-node
cluster listens on port `4000` on your host.

### 2 - Install Certificates

Run `install-certs.sh` to copy the example CA certificate and create a PKCS #12
(`.pfx`) bundle for the client certificate and private key.

The script also installs the CA certificate into your user trust store so the
Aerospike C# client can validate the server certificate. The client certificate
bundle is used for mutual TLS (mTLS) when the server requires client
authentication.

The default PKCS #12 password is `changeit`.

_Note: The default password `changeit` should never be used in production._

```
$ ./install-certs.sh
```

Output:

```
Creating TrustStore directory: 'etc/pki/certs'
Creating KeyStore directory: 'etc/pki/private'
Copying etc/pki/certs/example.ca.crt
Creating etc/pki/private/example.client.pfx
Installing CA certificate into the user trust store
---
etc/pki/certs/example.ca.crt
etc/pki/private/example.client.chain.crt
etc/pki/private/example.client.pfx
```

### 3 - Build Example Application

Restore dependencies and build the example:

```
$ dotnet build
```

### 4a - Run Example Application (Standard TLS)

With Aerospike Server running using the standard TLS configuration file
(`aerospike-tls.conf`) described in the
[main README](https://github.com/aerospike-examples/aerospike-tls-examples/blob/master/README.md),
run:

```
$ dotnet run
```

Output:

```
Aerospike Client [INFO]: Add node A1 127.0.0.1 4000
Aerospike Client [DEBUG]: Update peers for node A1 127.0.0.1 4000
Aerospike Client [DEBUG]: Update partition map for node A1 127.0.0.1 4000
Aerospike Client [DEBUG]: Add seed 127.0.0.1 4000
*** SUCCESS ***
```

### 4b - Run Example Application (Mutual TLS)

With Aerospike Server running using the mutual TLS configuration file
(`aerospike-mtls.conf`) described in the
[main README](https://github.com/aerospike-examples/aerospike-tls-examples/blob/master/README.md),
pass the
client certificate created by `install-certs.sh`:

```
$ dotnet run -- --mtls
```

Output:

```
Aerospike Client [INFO]: Add node A1 127.0.0.1 4000
Aerospike Client [DEBUG]: Update peers for node A1 127.0.0.1 4000
Aerospike Client [DEBUG]: Update partition map for node A1 127.0.0.1 4000
Aerospike Client [DEBUG]: Add seed 127.0.0.1 4000
*** SUCCESS ***
```

Troubleshooting
--------------------------------------------------------------------------------

Look at the log output from Aerospike Server as well as the application log
output when troubleshooting.

If certificate validation fails, confirm that `./install-certs.sh` completed
successfully and that the CA certificate is trusted by your operating system.

For mTLS failures, confirm Aerospike Server is running with
`aerospike-mtls.conf` and that you passed `--mtls` when running the example.

Enable debug logging in the Aerospike C# client by setting the log level before
connecting (already enabled in `Program.cs`):

```csharp
Log.SetLevel(Log.Level.DEBUG);
```

See [Connecting with TLS](https://aerospike.com/docs/develop/client/csharp/connect/) and the
[TlsPolicy API reference](https://aerospike.com/apidocs/csharp/api/Aerospike.Client.TlsPolicy.html)
for additional TLS configuration options.
