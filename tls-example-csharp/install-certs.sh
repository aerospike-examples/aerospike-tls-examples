#!/usr/bin/env bash

# Add certificates for testing Aerospike with TLS enabled in .NET applications.

set -euo pipefail

PREFIX='example'
TRUSTSTORE_DIR="etc/pki/certs"
KEYSTORE_DIR="etc/pki/private"
KEYSTORE_PASSWORD="changeit"

if [[ -n "${CERT_DIR:-}" ]]; then
  :
elif [[ -f "../certs/${PREFIX}.ca.crt" ]]; then
  # tls-example-csharp/ inside aerospike-tls-examples
  CERT_DIR="../certs"
elif [[ -f "../aerospike-tls-examples/certs/${PREFIX}.ca.crt" ]]; then
  # sibling of aerospike-tls-examples (e.g. ~/dev/tls-example-csharp)
  CERT_DIR="../aerospike-tls-examples/certs"
else
  echo "Missing example CA certificate."
  echo "Set CERT_DIR to the directory containing ${PREFIX}.ca.crt, or clone"
  echo "https://github.com/aerospike-examples/aerospike-tls-examples and run"
  echo "./generate-certs.sh from that repository root."
  exit 1
fi

echo "Creating TrustStore directory: '${TRUSTSTORE_DIR}'"
mkdir -p "${TRUSTSTORE_DIR}"
echo "Creating KeyStore directory: '${KEYSTORE_DIR}'"
mkdir -p "${KEYSTORE_DIR}"

echo "Copying ${TRUSTSTORE_DIR}/${PREFIX}.ca.crt"
cp "${CERT_DIR}/${PREFIX}.ca.crt" "${TRUSTSTORE_DIR}/"

echo "Creating ${KEYSTORE_DIR}/${PREFIX}.client.pfx"
cat "${CERT_DIR}/${PREFIX}.client.crt" "${CERT_DIR}/${PREFIX}.client.key" \
  > "${KEYSTORE_DIR}/${PREFIX}.client.chain.crt"
openssl pkcs12 -export \
  -in "${KEYSTORE_DIR}/${PREFIX}.client.chain.crt" \
  -out "${KEYSTORE_DIR}/${PREFIX}.client.pfx" \
  -password pass:"${KEYSTORE_PASSWORD}" \
  -name "${PREFIX}.client" -noiter -nomaciter

echo "Installing CA certificate into the user trust store"
if [[ "$(uname -s)" == "Darwin" ]]; then
  security add-trusted-cert -r trustAsRoot -p ssl \
    -k "${HOME}/Library/Keychains/login.keychain-db" \
    "${TRUSTSTORE_DIR}/${PREFIX}.ca.crt" \
    || security add-trusted-cert -d -r trustRoot \
    -k "${HOME}/Library/Keychains/login.keychain-db" \
    "${TRUSTSTORE_DIR}/${PREFIX}.ca.crt"
elif [[ "$(uname -s)" == "Linux" ]]; then
  if command -v update-ca-certificates >/dev/null 2>&1; then
    sudo cp "${TRUSTSTORE_DIR}/${PREFIX}.ca.crt" \
      "/usr/local/share/ca-certificates/${PREFIX}.ca.crt"
    sudo update-ca-certificates
  else
    echo "Install ${TRUSTSTORE_DIR}/${PREFIX}.ca.crt into your system CA trust store manually."
  fi
else
  echo "Install ${TRUSTSTORE_DIR}/${PREFIX}.ca.crt into your system CA trust store manually."
fi

echo "---"
if command -v tree >/dev/null 2>&1; then
  tree "${TRUSTSTORE_DIR}" "${KEYSTORE_DIR}"
else
  find "${TRUSTSTORE_DIR}" "${KEYSTORE_DIR}" -type f | sort
fi

echo "---"
openssl pkcs12 -info -in "${KEYSTORE_DIR}/${PREFIX}.client.pfx" \
  -passin pass:"${KEYSTORE_PASSWORD}" -nokeys 2>/dev/null | head -5 || true
