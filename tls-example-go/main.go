package main

import (
	"crypto/tls"
	"crypto/x509"
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"runtime"

	as "github.com/aerospike/aerospike-client-go/v8"
	asl "github.com/aerospike/aerospike-client-go/v8/logger"
)

const tlsName = "example.server"

var useMutualTLS = flag.Bool("mtls", false, "Enable mutual TLS (client certificate authentication)")

func main() {
	flag.Parse()

	// Setup debug logging in the Aerospike client to help with troubleshooting.
	asl.Logger.SetLevel(asl.DEBUG)

	certDir, err := certDirectory()
	if err != nil {
		log.Fatal(err)
	}

	caCert, err := os.ReadFile(filepath.Join(certDir, "example.ca.crt"))
	if err != nil {
		log.Fatalf("read CA certificate: %v (run ../generate-certs.sh first)", err)
	}

	serverPool := x509.NewCertPool()
	if ok := serverPool.AppendCertsFromPEM(caCert); !ok {
		log.Fatal("unable to parse CA certificate")
	}

	tlsConfig := &tls.Config{
		ServerName:               tlsName,
		RootCAs:                  serverPool,
		PreferServerCipherSuites: true,
		CipherSuites: []uint16{
			tls.TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
		},
	}

	if *useMutualTLS {
		clientCert, err := tls.LoadX509KeyPair(
			filepath.Join(certDir, "example.client.crt"),
			filepath.Join(certDir, "example.client.key"),
		)
		if err != nil {
			log.Fatalf("load client certificate: %v", err)
		}
		tlsConfig.Certificates = []tls.Certificate{clientCert}
	}

	clientPolicy := as.NewClientPolicy()
	clientPolicy.TlsConfig = tlsConfig

	// The TLS name must match the Common Name (CN) or Subject Alternative Name (SAN)
	// in the server certificate and the tls-name in aerospike.conf.
	host := as.NewHost("127.0.0.1", 4000)
	host.TLSName = tlsName

	client, err := as.NewClientWithPolicyAndHost(clientPolicy, host)
	if err != nil {
		log.Fatalf("connection failed: %v", err)
	}
	defer client.Close()

	fmt.Println("*** SUCCESS ***")
}

func certDirectory() (string, error) {
	_, filename, _, ok := runtime.Caller(0)
	if !ok {
		return "", fmt.Errorf("unable to determine example directory")
	}
	return filepath.Join(filepath.Dir(filename), "..", "certs"), nil
}
