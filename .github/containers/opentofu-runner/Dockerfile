FROM alpine:3.21 AS tofu
ARG TARGETARCH
ARG VERSION

# Install needed tools
RUN apk add --no-cache util-linux curl jq yq \
  && curl -fsSL "https://github.com/opentofu/opentofu/releases/download/v${VERSION}/tofu_${VERSION}_linux_${TARGETARCH}.tar.gz" \
  | tar xzf - -C /tmp

FROM ghcr.io/flux-iac/tf-runner:v0.16.0-rc.5
USER root

# Copy binaries from Alpine builder stage
COPY --from=tofu /usr/bin/flock /usr/bin/flock
COPY --from=tofu /usr/bin/jq /usr/local/bin/jq
COPY --from=tofu /usr/bin/yq /usr/local/bin/yq
COPY --from=tofu /tmp/tofu /usr/local/bin/tofu

USER 65532:65532
