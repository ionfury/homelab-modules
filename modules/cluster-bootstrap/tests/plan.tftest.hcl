run "plan" {
  command = plan
  variables {
    cluster_name = "plan"
    flux_version = "v2.4.0"
    tld          = "tomnowak.work"

    cluster_env_vars = {
      hello = "world"
    }

    kubeconfig = {
      host                   = "https://127.0.0.1:6443"
      client_certificate     = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJoVENDQVN1Z0F3SUJBZ0lSQU1nWUJ4d0tOUm5sMjdKN1pablE5UDR3Q2dZSUtvWkl6ajBFQXdJd0ZURVQKTUJFR0ExVUVDaE1LYTNWaVpYSnVaWFJsY3pBZUZ3MHlOVEF4TXpFd05ETTVNVFphRncweU5qQXhNekV3TkRNNQpNalphTUNreEZ6QVZCZ05WQkFvVERuTjVjM1JsYlRwdFlYTjBaWEp6TVE0d0RBWURWUVFERXdWaFpHMXBiakJaCk1CTUdCeXFHU000OUFnRUdDQ3FHU000OUF3RUhBMElBQkhreXBkL0NiOW1JSnUraE1XMEY1UFVkMEF4cGl5aWQKTy9sbXphR2NsamlPSFBaM0lna2lheFQ3bHdOUHErTWhsMmwyZVNKcE9VcGpkbWlaUmVGdlZhZWpTREJHTUE0RwpBMVVkRHdFQi93UUVBd0lGb0RBVEJnTlZIU1VFRERBS0JnZ3JCZ0VGQlFjREFqQWZCZ05WSFNNRUdEQVdnQlNRCmlyUmsrbXF6ODUxQWgwVDY2amhIejdIMm1UQUtCZ2dxaGtqT1BRUURBZ05JQURCRkFpQnVrZ01JeHpTU1p3eTEKRmZJTWY0d3ZTN0tsOXYwSWVXTXNsT1RROVc3SElRSWhBSitvdmNZaXZsdEdITE5hejVMV0txVlJBZE9sUTBXZwpLbFYrSnEvZ2k5ekEKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo="
      client_key             = "LS0tLS1CRUdJTiBFQyBQUklWQVRFIEtFWS0tLS0tCk1IY0NBUUVFSUk4L2FjUEVMWTZoUE9Vcmh4Y2hSSm12QzN5MDNnYUZmVUl0UjczdFREUURvQW9HQ0NxR1NNNDkKQXdFSG9VUURRZ0FFZVRLbDM4SnYyWWdtNzZFeGJRWGs5UjNRREdtTEtKMDcrV2JOb1p5V09JNGM5bmNpQ1NKcgpGUHVYQTArcjR5R1hhWFo1SW1rNVNtTjJhSmxGNFc5VnB3PT0KLS0tLS1FTkQgRUMgUFJJVkFURSBLRVktLS0tLQo="
      cluster_ca_certificate = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJpVENDQVRDZ0F3SUJBZ0lSQUtMVnNmN0Q4MW5qSmI5eXkyU3RUTDh3Q2dZSUtvWkl6ajBFQXdJd0ZURVQKTUJFR0ExVUVDaE1LYTNWaVpYSnVaWFJsY3pBZUZ3MHlOVEF4TXpFd05ETTRNemxhRncwek5UQXhNamt3TkRNNApNemxhTUJVeEV6QVJCZ05WQkFvVENtdDFZbVZ5Ym1WMFpYTXdXVEFUQmdjcWhrak9QUUlCQmdncWhrak9QUU1CCkJ3TkNBQVJldlJQYkVBT1Y1Wk5PRDRjaDZ2eDAyUjMzR3J0WHBSbXR5QUxrV3R6eHZsMjRqaVJ0VGtzUk9qWFIKN3BhUVVkQ1Iwekg1TjVSWTNXY0l4S1UxSlNwcW8yRXdYekFPQmdOVkhROEJBZjhFQkFNQ0FvUXdIUVlEVlIwbApCQll3RkFZSUt3WUJCUVVIQXdFR0NDc0dBUVVGQndNQ01BOEdBMVVkRXdFQi93UUZNQU1CQWY4d0hRWURWUjBPCkJCWUVGSkNLdEdUNmFyUHpuVUNIUlBycU9FZlBzZmFaTUFvR0NDcUdTTTQ5QkFNQ0EwY0FNRVFDSUVJYWJGU04KYTZZZjc2cWRMU0ZDd1JMM3dYZG1JZEVFK3RucElnSGV4NkVzQWlCT2Y2UWtPT0E2Y2NUSFFnMmJML1lML3ZaVApVK2Rtc3dJanFRM2lZaWhpOVE9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg=="
    }

    aws = {
      region = "us-east-2"
    }

    github = {
      org             = "ionfury"
      repository      = "homelab"
      repository_path = "kubernetes/clusters"
      token           = "/homelab/integration/accounts/github/token"
    }

    cloudflare = {
      account   = "homelab"
      email     = "ionfury@gmail.com"
      api_token = "/homelab/integration/accounts/cloudflare/token"
      zone_id   = "test"
    }

    external_secrets = {
      id     = "/homelab/integration/accounts/external-secrets/id"
      secret = "/homelab/integration/accounts/external-secrets/secret"
    }

    healthchecksio = {
      api_key = "/homelab/integration/accounts/healthchecksio/api-key"
    }
  }
}
