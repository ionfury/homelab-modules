# syntax=docker/dockerfile:1

ARG VERSION=2.324.0
FROM ghcr.io/actions/actions-runner:${VERSION}

ENV HOMEBREW_NO_ANALYTICS=1 \
  HOMEBREW_NO_ENV_HINTS=1 \
  HOMEBREW_NO_INSTALL_CLEANUP=1 \
  TF_IN_AUTOMATION=1 \
  PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  curl \
  file \
  git \
  procps \
  && rm -rf /var/lib/apt/lists/*

USER runner
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
  && echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc

COPY Brewfile /home/runner/Brewfile
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
  && brew update \
  && brew bundle --file=/home/runner/Brewfile \
  && brew cleanup --prune=all

RUN tofuenv install latest && tofuenv use latest