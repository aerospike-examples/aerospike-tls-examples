using System.Security.Cryptography.X509Certificates;
using Aerospike.Client;

namespace Aerospike.Examples;

internal static class Program
{
    private const string Prefix = "example";
    private const string KeyStorePassword = "changeit";

    private static readonly string ProjectDir = Directory.GetCurrentDirectory();
    private static readonly string TrustStoreDir = Path.Combine(ProjectDir, "etc", "pki", "certs");
    private static readonly string KeyStoreDir = Path.Combine(ProjectDir, "etc", "pki", "private");

    public static int Main(string[] args)
    {
        bool useMutualTls = args.Any(arg => arg.Equals("--mtls", StringComparison.OrdinalIgnoreCase));

        Log.SetCallback((level, message) =>
            Console.WriteLine($"Aerospike Client [{level}]: {message}"));
        Log.SetLevel(Log.Level.DEBUG);

        ClientPolicy policy = new()
        {
            tlsPolicy = new TlsPolicy()
        };

        if (useMutualTls)
        {
            string clientPfx = Path.Combine(KeyStoreDir, $"{Prefix}.client.pfx");
            if (!File.Exists(clientPfx))
            {
                Console.Error.WriteLine(
                    $"Client certificate not found at '{clientPfx}'. Run ./install-certs.sh first.");
                return 1;
            }

            X509Certificate2 clientCert = new(clientPfx, KeyStorePassword);
            policy.tlsPolicy!.clientCertificates =
                new X509CertificateCollection(new X509Certificate[] { clientCert });
        }

        // The TLS name must match the Common Name (CN) or Subject Alternative Name (SAN)
        // in the server certificate and the tls-name in aerospike.conf.
        Host host = new("127.0.0.1", "example.server", 4000);

        try
        {
            using AerospikeClient client = new(policy, host);
            Console.WriteLine("*** SUCCESS ***");
            return 0;
        }
        catch (Exception ex)
        {
            Console.Error.WriteLine($"Connection failed: {ex.Message}");
            Console.Error.WriteLine();
            Console.Error.WriteLine(
                "Ensure Aerospike Server is running with TLS on port 4000 and that the CA " +
                $"certificate is trusted. Run ./install-certs.sh from this directory.");
            if (!useMutualTls)
            {
                Console.Error.WriteLine(
                    "For mutual TLS, run with: dotnet run -- --mtls");
            }
            return 1;
        }
    }
}
