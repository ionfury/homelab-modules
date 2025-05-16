FROM alpine:3.21 AS tofu
ARG TARGETARCH
ARG VERSION
RUN apk add --no-cache curl \
  && curl -fsSL "https://github.com/opentofu/opentofu/releases/download/v${VERSION}/tofu_${VERSION}_linux_${TARGETARCH}.tar.gz" \
  | tar xzf - -C /tmp

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
  curl \
  jq \
  ca-certificates \
  && curl -fsSL https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /usr/local/bin/yq \
  && chmod +x /usr/local/bin/yq \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=tofu /tmp/tofu /usr/local/bin/tofu
