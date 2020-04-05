import os
import aerospike

THIS_DIR = os.path.abspath(os.path.dirname(__file__))

def log_callback(level, func, path, line, msg):
    print("[{}] {}".format(func, msg))

if __name__ == "__main__":

    # Setup debug logging in the Aerospike client to help with troubleshooting
    aerospike.set_log_level(aerospike.LOG_LEVEL_DEBUG)
    aerospike.set_log_handler(log_callback)

    config = {
        # The 'tls-name' (third element in tuple) must be specified when using
        # TLS. The 'tls-name' must match the Common Name (CN) or a Subject 
        # Alternative Name (SAN) found in the certificate.
        'hosts': [('127.0.0.1', 4000, 'example.server')],
        'tls': {
            # TLS must be explicitly enabled
            'enable': True,

            # The CA certificate can alternatively be installed in the system
            # trusted CA certificate directory if security requirements allow
            # system-wide CA trust.
            'cafile': os.path.join(THIS_DIR, '..', 'certs', 'example.ca.crt'),

            # For mTLS the client must present it's public certificate to the
            # server during the TLS handshake. This can be removed if Aerospike
            # Server is not configured for mutual TLS (tls-authenticate-client = false)
            'certfile': os.path.join(THIS_DIR, '..', 'certs', 'example.client.crt'),

            # For mTLS the client will need the private key to encrypt messages
            # sent to the server during the TLS handshake. This can be removed
            # if Aerospike Server is not configured for mutual TLS
            # (tls-authenticate-client = false)
            'keyfile': os.path.join(THIS_DIR, '..', 'certs', 'example.client.key'),

            # The 'cipher_suite' property is optional, however, it is recommended
            # to provide a list of valid cipher suites to ensure less secure or
            # poor-performing algorithms are not available. The cipher suites
            # can be specified in the 'cipher_suite' as shown below, they can be
            # specified in the Aerospike configuration using the 'cipher-suite'
            # directive, or both.
            'cipher_suite': 'ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-GCM-SHA256'
        }
    }

    client = aerospike.client(config).connect()

    print("*** SUCCESS ***")

    client.close()
