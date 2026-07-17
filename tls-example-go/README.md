Aerospike TLS Example in Go
================================================================================

Example Go application demonstrating how to connect to Aerospike Server
Enterprise with standard TLS or mutual authentication TLS (mTLS).

Before running this example, run `./generate-certs.sh` from the root of the
[aerospike-tls-examples](https://github.com/aerospike-examples/aerospike-tls-examples)
repository. The example loads certificates from `../certs`.

### Prerequisites

* [Go 1.21 or later](https://go.dev/dl/) (verify with: `go version`)
* [Aerospike Go Client](https://aerospike.com/docs/develop/client/go/)

Quick Start
--------------------------------------------------------------------------------

### 1 - Run Aerospike Server Enterprise

Follow the __Quick Start__ steps in the [main README](../README.md) to setup
Aerospike Server Enterprise in Docker which has been configured to use TLS. This
is a single-node Aerospike cluster which will be available at your host's IP
address on port `4000`.

### 2 - Build Example Application

From this directory:

```
$ go build -o tls-example-go .
```

### 3a - Run Example Application (Standard TLS)

With Aerospike Server running with the standard TLS configuration file as
described in the [main README](../README.md), run:

```
$ ./tls-example-go
```

Output:

```
Aerospike Client [INFO]: Add node A1 127.0.0.1 4000
Aerospike Client [DEBUG]: Update peers for node A1 127.0.0.1 4000
Aerospike Client [DEBUG]: Update partition map for node A1 127.0.0.1 4000
Aerospike Client [DEBUG]: Add seed 127.0.0.1 4000
*** SUCCESS ***
```

### 3b - Run Example Application (Mutual TLS)

With Aerospike Server running with the mutual TLS (mTLS) configuration file
as described in the [main README](../README.md), pass the client certificate
created by `generate-certs.sh`:

```
$ ./tls-example-go --mtls
```

Output:

```
Aerospike Client [INFO]: Add node A1 127.0.0.1 4000
Aerospike Client [DEBUG]: Update peers for node A1 127.0.0.1 4000
Aerospike Client [DEBUG]: Update partition map for node A1 127.0.0.1 4000
Aerospike Client [DEBUG]: Add seed 127.0.0.1 4000
*** SUCCESS ***
```

You can also run without building first:

```
$ go run .              # standard TLS
$ go run . -- --mtls    # mutual TLS
```

Troubleshooting
--------------------------------------------------------------------------------

Look at the log output from the Aerospike Server as well as the application log
output when troubleshooting.

If certificate validation fails, confirm that `./generate-certs.sh` completed
successfully and that `../certs/example.ca.crt` exists.

For mTLS failures, confirm Aerospike Server is running with `aerospike-mtls.conf`
and that you passed `--mtls` when running the example.

Enable debug logging in the Aerospike Go client by setting the log level before
connecting (already enabled in `main.go`):

```go
import asl "github.com/aerospike/aerospike-client-go/v8/logger"

asl.Logger.SetLevel(asl.DEBUG)
```

See [Managing mTLS with the Go client](https://aerospike.com/docs/develop/client/go/mtls/)
for additional TLS configuration options.
