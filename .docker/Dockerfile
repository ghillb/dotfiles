FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install --yes --no-install-recommends git stow \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --shell /bin/bash --uid 1000 dv

USER dv
ENV USER=dv
WORKDIR /home/dv
COPY --chown=dv:dv . /home/dv/.files
RUN /home/dv/.files/.agents/skills/setup-dotfiles/scripts/deploy.sh

CMD ["/bin/bash"]
