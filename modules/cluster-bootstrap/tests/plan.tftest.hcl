run "get" {
  module {
    source = "./tests/harness/aws_ssm_params_get"
  }

  variables {
    parameters = [
      "/homelab/integration/accounts/github/token",
      "/homelab/integration/accounts/cloudflare/token",
      "/homelab/integration/accounts/external-secrets/id",
      "/homelab/integration/accounts/external-secrets/secret",
      "/homelab/integration/accounts/healthchecksio/api-key"
    ]
  }
}

run "plan" {
  command = plan
  variables {
    cluster_name = "plan"
    flux_version = "v2.4.0"
    tld          = "tomnowak.work"

    cluster_env_vars = [{
      name  = "hello"
      value = "world"
    }]

    kubeconfig = {
      # These are not real credentials, and were generated specifically to meet the validation requirements on the kubernetes provider input to do a plan.
      host                   = "https://127.0.0.1:6443"
      client_certificate     = <<EOT
-----BEGIN CERTIFICATE-----
MIIBhTCCASugAwIBAgIRAMgYBxwKNRnl27J7ZZnQ9P4wCgYIKoZIzj0EAwIwFTET
MBEGA1UEChMKa3ViZXJuZXRlczAeFw0yNTAxMzEwNDM5MTZaFw0yNjAxMzEwNDM5
MjZaMCkxFzAVBgNVBAoTDnN5c3RlbTptYXN0ZXJzMQ4wDAYDVQQDEwVhZG1pbjBZ
MBMGByqGSM49AgEGCCqGSM49AwEHA0IABHkypd/Cb9mIJu+hMW0F5PUd0Axpiyid
O/lmzaGcljiOHPZ3IgkiaxT7lwNPq+Mhl2l2eSJpOUpjdmiZReFvVaejSDBGMA4G
A1UdDwEB/wQEAwIFoDATBgNVHSUEDDAKBggrBgEFBQcDAjAfBgNVHSMEGDAWgBSQ
irRk+mqz851Ah0T66jhHz7H2mTAKBggqhkjOPQQDAgNIADBFAiBukgMIxzSSZwy1
FfIMf4wvS7Kl9v0IeWMslOTQ9W7HIQIhAJ+ovcYivltGHLNaz5LWKqVRAdOlQ0Wg
KlV+Jq/gi9zA
-----END CERTIFICATE-----
EOT
      client_key             = <<EOT
-----BEGIN EC PRIVATE KEY-----
MHcCAQEEII8/acPELY6hPOUrhxchRJmvC3y03gaFfUItR73tTDQDoAoGCCqGSM49
AwEHoUQDQgAEeTKl38Jv2Ygm76ExbQXk9R3QDGmLKJ07+WbNoZyWOI4c9nciCSJr
FPuXA0+r4yGXaXZ5Imk5SmN2aJlF4W9Vpw==
-----END EC PRIVATE KEY-----
EOT
      cluster_ca_certificate = <<EOT
-----BEGIN CERTIFICATE-----
MIIBiTCCATCgAwIBAgIRAKLVsf7D81njJb9yy2StTL8wCgYIKoZIzj0EAwIwFTET
MBEGA1UEChMKa3ViZXJuZXRlczAeFw0yNTAxMzEwNDM4MzlaFw0zNTAxMjkwNDM4
MzlaMBUxEzARBgNVBAoTCmt1YmVybmV0ZXMwWTATBgcqhkjOPQIBBggqhkjOPQMB
BwNCAARevRPbEAOV5ZNOD4ch6vx02R33GrtXpRmtyALkWtzxvl24jiRtTksROjXR
7paQUdCR0zH5N5RY3WcIxKU1JSpqo2EwXzAOBgNVHQ8BAf8EBAMCAoQwHQYDVR0l
BBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0O
BBYEFJCKtGT6arPznUCHRPrqOEfPsfaZMAoGCCqGSM49BAMCA0cAMEQCIEIabFSN
a6Yf76qdLSFCwRL3wXdmIdEE+tnpIgHex6EsAiBOf6QkOOA6ccTHQg2bL/YL/vZT
U+dmswIjqQ3iYihi9Q==
-----END CERTIFICATE-----
EOT
    }

    github = {
      org             = "ionfury"
      repository      = "homelab"
      repository_path = "kubernetes/clusters"
      token           = run.get.values["/homelab/integration/accounts/github/token"]
    }

    cloudflare = {
      account   = "homelab"
      email     = "ionfury@gmail.com"
      api_token = run.get.values["/homelab/integration/accounts/cloudflare/token"]
      zone_id   = "test"
    }

    external_secrets = {
      id     = run.get.values["/homelab/integration/accounts/external-secrets/id"]
      secret = run.get.values["/homelab/integration/accounts/external-secrets/secret"]
    }

    healthchecksio = {
      api_key = run.get.values["/homelab/integration/accounts/healthchecksio/api-key"]
    }
  }

  assert {
    condition     = helm_release.flux_instance.values[0] == "instance:\n  components:\n    - source-controller\n    - kustomize-controller\n    - helm-controller\n    - notification-controller\n    - image-reflector-controller\n    - image-automation-controller\n  distribution:\n    version: v2.4.0\n  cluster:\n    size: small\n  sync:\n    kind: GitRepository\n    url: https://github.com/ionfury/homelab\n    path: kubernetes/clusters/plan\n    ref: refs/heads/main\n    provider: generic\n    pullSecret: flux-system\nhealthcheck:\n  enabled: true"
    error_message = "Incorrect helm flux instance values: ${helm_release.flux_instance.values[0]}"
  }
}
