Aerospike TLS Example in Python
================================================================================

Example Python application demonstrating how to connect to Aerospike Server
Enterprise with standard TLS or mutual authentication TLS (mTLS).

### Prerequisites

* Python (verify with: `python -V` or `python3 -V`)
* [Aerospike Python Client](https://www.aerospike.com/docs/client/python/)


Quick Start
--------------------------------------------------------------------------------

### 1 - Run Aerospike Server Enterprise

Follow the __Quick Start__ steps in the [main README](../README.md) to setup
Aerospike Server Enterprise in Docker which has been configured to use TLS. This
is a single-node Aerospike cluster which will be available at your host's IP
address on port `4000`.


### 2 - Run Example Application

With Aerospike Server running with either the standard TLS configuration file or
with the mutual TLS (mTLS) configuration file as described in the
[main README](../README.md), run `tls-example.py`:

```
$ python3 tls-example.py
```

Output:
```
[as_tls_context_setup] cipher 1: TLS_AES_256_GCM_SHA384
[as_tls_context_setup] cipher 2: TLS_CHACHA20_POLY1305_SHA256
[as_tls_context_setup] cipher 3: TLS_AES_128_GCM_SHA256
[as_tls_context_setup] cipher 4: TLS_AES_128_CCM_SHA256
[as_tls_context_setup] cipher 5: ECDHE-RSA-AES256-GCM-SHA384
[as_tls_context_setup] cipher 6: ECDHE-ECDSA-AES256-GCM-SHA384
[as_tls_context_setup] cipher 7: ECDHE-RSA-AES128-GCM-SHA256
[as_tls_context_setup] cipher 8: ECDHE-ECDSA-AES128-GCM-SHA256
[as_tls_context_setup] cipher 9: AES256-GCM-SHA384
[as_tls_context_setup] cipher 10: AES128-GCM-SHA256
[verify_callback] TLS name 'example.server' matches
[as_cluster_add_nodes_copy] Add node A1 127.0.0.1:4000
[verify_callback] TLS name 'example.server' matches
[as_node_process_response] Node A1 peers generation changed: 0
[as_node_process_response] Node A1 partition generation changed: 0
*** SUCCESS ***
```
