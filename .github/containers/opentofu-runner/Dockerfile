FROM alpine:3.21 AS tofu
ARG TARGETARCH
ARG VERSION
RUN apk add --no-cache curl \
  && curl -fsSL "https://github.com/opentofu/opentofu/releases/download/v${VERSION}/tofu_${VERSION}_linux_${TARGETARCH}.tar.gz" \
  | tar xzf - -C /tmp

FROM debian:bookworm-slim
COPY --from=tofu /tmp/tofu /usr/local/bin/tofu