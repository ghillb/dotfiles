FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -o Acquire::ForceIPv4=true -o Acquire::Retries=3 update \
    && apt-get -o Acquire::ForceIPv4=true --yes --no-install-recommends install git stow \
    && rm -rf /var/lib/apt/lists/* \
    && existing_user="$(getent passwd 1000 | cut -d: -f1)" \
    && if [ -n "$existing_user" ]; then userdel --remove "$existing_user"; fi \
    && useradd --create-home --shell /bin/bash --uid 1000 --user-group dv

USER dv
ENV USER=dv
WORKDIR /home/dv
COPY --chown=dv:dv . /home/dv/.files
RUN /home/dv/.files/.agents/skills/setup-dotfiles/scripts/deploy.sh

CMD ["/bin/bash"]
