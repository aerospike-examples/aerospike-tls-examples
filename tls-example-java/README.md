Aerospike TLS Example in Java
================================================================================

Example Java application demonstrating how to connect to Aerospike Server
Enterprise with standard TLS or mutual authentication TLS (mTLS).

### Prerequisites

* Java Development Kit (JDK) (verify with: `javac -version`)
* Maven (verify with: `mvn -version`)


Quick Start
--------------------------------------------------------------------------------

### 1 - Run Aerospike Server Enterprise

Follow the __Quick Start__ steps in the [main README](../README.md) to setup
Aerospike Server Enterprise in Docker which has been configured to use TLS. This
is a single-node Aerospike cluster which will be available at your host's IP
address on port `4000`.


### 2 - Install Certificates

Run `install-certs.sh` to create the Java TrustStore containing the CA
certificate used to sign the server's certificate and the KeyStore containing
the client private key and certificate pair. The CA certificate (TrustStore) is
used to verify the certificate presented by the server and the client private
key and certificate (KeyStore) is used in mutual authentication (mTLS) where the
client is also presenting a certificate to the server.

The Java default password of "changeit" is used for the TrustStore and KeyStore
in this example.

_Note: The default password "changeit" should never be used in production._

```
$ ./install-certs.sh
```

Output:
```
Creating TrustStore directory: 'etc/pki/certs'
Creating KeyStore directory: 'etc/pki/private'
Creating etc/pki/certs/example.ca.jks
Certificate was added to keystore
Creating etc/pki/private/example.client.p12
---
etc/pki/certs/example.ca.jks
keytool error: java.lang.Exception: Keystore file does not exist: etc/pki/certs/example.ca.p12
---
etc/pki/private/example.client.chain.p12
Keystore type: PKCS12
Keystore provider: SUN

Your keystore contains 1 entry

example.client, Apr 5, 2020, PrivateKeyEntry, 
Certificate fingerprint (SHA1): A3:63:D6:B0:3B:E9:7E:78:81:46:5F:D6:53:93:5D:57:27:1B:FE:6D
---
etc/pki/certs
├── example.ca.crt
└── example.ca.jks
etc/pki/private
├── example.client.chain.crt
└── example.client.chain.p12
```

### 3 - Build Example Application

Build the example Java application:

```
$ mvn package
```


### 4a - Run Example Application (Standard TLS)

With Aerospike Server running with the standard TLS configuration file as
described in the [main README](../README.md), run the `jar` file. The
TrustStore created by `install-certs.sh` is passed to the JVM using 
`-Djavax.net.ssl.trustStore`:

```
$ java -Djavax.net.ssl.trustStore=etc/pki/certs/example.ca.jks \
-jar target/aerospike-tls-example-1.0-jar-with-dependencies.jar
```

Output:
```
Available Cipher Suites:
 [ ] TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384
 [ ] TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384
 [ ] TLS_RSA_WITH_AES_256_CBC_SHA256
 [ ] TLS_DHE_RSA_WITH_AES_256_CBC_SHA256
 [ ] TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA
 [ ] TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA
 [ ] TLS_RSA_WITH_AES_256_CBC_SHA
 [ ] TLS_DHE_RSA_WITH_AES_256_CBC_SHA
 [ ] TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256
 [ ] TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256
 [ ] TLS_RSA_WITH_AES_128_CBC_SHA256
 [ ] TLS_DHE_RSA_WITH_AES_128_CBC_SHA256
 [ ] TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA
 [ ] TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA
 [ ] TLS_RSA_WITH_AES_128_CBC_SHA
 [ ] TLS_DHE_RSA_WITH_AES_128_CBC_SHA
 [x] TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
 [x] TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
 [x] TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
 [ ] TLS_RSA_WITH_AES_256_GCM_SHA384
 [ ] TLS_DHE_RSA_WITH_AES_256_GCM_SHA384
 [x] TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
 [ ] TLS_RSA_WITH_AES_128_GCM_SHA256
 [ ] TLS_DHE_RSA_WITH_AES_128_GCM_SHA256
 [ ] TLS_EMPTY_RENEGOTIATION_INFO_SCSV
 [ ] TLS_RSA_WITH_NULL_SHA256
 [ ] TLS_ECDHE_ECDSA_WITH_NULL_SHA
 [ ] TLS_ECDHE_RSA_WITH_NULL_SHA
 [ ] SSL_RSA_WITH_NULL_SHA
Aerospike Client [INFO]: Add node A1 127.0.0.1 4000
Aerospike Client [DEBUG]: Update peers for node A1 127.0.0.1 4000
Aerospike Client [DEBUG]: Update partition map for node A1 127.0.0.1 4000
Aerospike Client [DEBUG]: Add seed 127.0.0.1 4000
*** SUCCESS ***
```

### 4b - Run Example Application (Mutual TLS)

With Aerospike Server running with the mutual TLS (mTLS) configuration file
as described in the [main README](../README.md), run the `jar` file. The
TrustStore, KeyStore, and KeyStore password created by `install-certs.sh` script
is passed to the JVM using `-Djavax.net.ssl.trustStore`,
`Djavax.net.ssl.keyStore`, and `-Djavax.net.ssl.keyStorePassword` respectively:

```
$ java -Djavax.net.ssl.trustStore=etc/pki/certs/example.ca.jks \
-Djavax.net.ssl.keyStore=etc/pki/private/example.client.chain.p12 \
-Djavax.net.ssl.keyStorePassword=changeit \
-jar target/aerospike-tls-example-1.0-jar-with-dependencies.jar
```

_Note: The default password "changeit" should never be used in production._

Output:
```
Available Cipher Suites:
 [ ] TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384
 [ ] TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384
 [ ] TLS_RSA_WITH_AES_256_CBC_SHA256
 [ ] TLS_DHE_RSA_WITH_AES_256_CBC_SHA256
 [ ] TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA
 [ ] TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA
 [ ] TLS_RSA_WITH_AES_256_CBC_SHA
 [ ] TLS_DHE_RSA_WITH_AES_256_CBC_SHA
 [ ] TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256
 [ ] TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256
 [ ] TLS_RSA_WITH_AES_128_CBC_SHA256
 [ ] TLS_DHE_RSA_WITH_AES_128_CBC_SHA256
 [ ] TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA
 [ ] TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA
 [ ] TLS_RSA_WITH_AES_128_CBC_SHA
 [ ] TLS_DHE_RSA_WITH_AES_128_CBC_SHA
 [x] TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
 [x] TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
 [x] TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
 [ ] TLS_RSA_WITH_AES_256_GCM_SHA384
 [ ] TLS_DHE_RSA_WITH_AES_256_GCM_SHA384
 [x] TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
 [ ] TLS_RSA_WITH_AES_128_GCM_SHA256
 [ ] TLS_DHE_RSA_WITH_AES_128_GCM_SHA256
 [ ] TLS_EMPTY_RENEGOTIATION_INFO_SCSV
 [ ] TLS_RSA_WITH_NULL_SHA256
 [ ] TLS_ECDHE_ECDSA_WITH_NULL_SHA
 [ ] TLS_ECDHE_RSA_WITH_NULL_SHA
 [ ] SSL_RSA_WITH_NULL_SHA
Aerospike Client [INFO]: Add node A1 127.0.0.1 4000
Aerospike Client [DEBUG]: Update peers for node A1 127.0.0.1 4000
Aerospike Client [DEBUG]: Update partition map for node A1 127.0.0.1 4000
Aerospike Client [DEBUG]: Add seed 127.0.0.1 4000
*** SUCCESS ***
```

Troubleshooting
--------------------------------------------------------------------------------

Look at the log output from the Aerospike Server as well as the application log
output when troubleshooting.

To help troubleshoot connection errors enable debugging output by passing
`-Djavax.net.debug=all` to the JVM when running the `jar`:

```
$ java -Djavax.net.debug=all \
-Djavax.net.ssl.trustStore=etc/pki/certs/example.ca.jks \
-jar target/aerospike-tls-example-1.0-jar-with-dependencies.jar
```