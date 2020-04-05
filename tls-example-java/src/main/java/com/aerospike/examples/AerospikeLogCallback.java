package com.aerospike.examples;

import com.aerospike.client.Log;

public class AerospikeLogCallback implements Log.Callback {

    public void log(Log.Level level, String message) {
        System.out.println("Aerospike Client [" + level + "]: " + message);
    }
}
