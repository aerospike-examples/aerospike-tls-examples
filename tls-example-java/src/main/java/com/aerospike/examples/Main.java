package com.aerospike.examples;

import javax.net.ssl.SSLContext;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;
import java.util.List;

import com.aerospike.client.AerospikeClient;
import com.aerospike.client.Host;
import com.aerospike.client.Log;
import com.aerospike.client.policy.ClientPolicy;
import com.aerospike.client.policy.TlsPolicy;

public class Main {

    public static void main(String[] args) {

        // Setup debug logging in the Aerospike client to help with troubleshooting
        Log.Callback logCallback = new AerospikeLogCallback();
        Log.setCallback(logCallback);
        Log.setLevel(Log.Level.DEBUG);

        // The 'tlsName' (second argument) must be specified when using TLS. The 'tlsName' must
        // match the Common Name (CN) or a Subject Alternative Name (SAN) found in the certificate.
        Host[] hosts = new Host[] {
                new Host("127.0.0.1", "example.server", 4000)
        };

        // A 'TlsPolicy' is required when using TLS.
        ClientPolicy policy = new ClientPolicy();
        policy.tlsPolicy = new TlsPolicy();


        // The 'TlsPolicy.ciphers` property is optional, however, it is recommended to provide a
        // list of valid cipher suites to ensure less secure or poor-performing algorithms are not
        // available. The cipher suites can be specified in the 'TlsPolicy' as shown below, they can
        // be specified in the Aerospike configuration using the 'cipher-suite' directive, or both.
        String[] ciphers = {
                "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384", // ECDHE-ECDSA-AES256-GCM-SHA384
                "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256", // ECDHE-RSA-AES128-GCM-SHA256
                "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",   // ECDHE-ECDSA-AES256-GCM-SHA384
                "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"    // ECDHE-ECDSA-AES256-GCM-SHA384
        };
        policy.tlsPolicy.ciphers = ciphers;

        // Print the list of cipher suites that are available to this Java runtime. This can be used
        // to help with troubleshooting. The list is prioritized which means the cipher suites
        // higher up the list are preferred by the client when the client and server perform the
        // TLS handshake.
        printCiphers(ciphers);

        // By instantiating AerospikeClient, connections will be established or an exception will
        // be thrown. When using TLS, the constructor which accepts 'ClientPolicy' and 'Hosts[]' is
        // used to specify the TLS policy and "tlsName" respectively.
        AerospikeClient client = new AerospikeClient(policy, hosts);

        System.out.println("*** SUCCESS ***");

        client.close();
    }

    /**
     * Print the list of cipher suites that are available to this Java runtime.
     */
    private static void printCiphers(String[] ciphers) {

        System.out.println("Available Cipher Suites:");
        List<String> selectedCiphers = Arrays.asList(ciphers);

        try {
            String[] allCiphers = SSLContext.getDefault().getSocketFactory().getSupportedCipherSuites();
            for (int i = 0; i<allCiphers.length; i++) {
                String indicator = " ";
                if (selectedCiphers.contains(allCiphers[i])) {
                    indicator = "x";
                }
                System.out.println(" [" + indicator + "] " + allCiphers[i]);
            }
        } catch (NoSuchAlgorithmException e) {
            System.out.println("Failed to get default SSL context.");
        }
    }
}
