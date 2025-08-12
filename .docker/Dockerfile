FROM ubuntu:24.04
USER root
ENV DEBIAN_FRONTEND="noninteractive" TZ="Europe/Berlin"
ENV CI=true
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y tzdata sudo git curl wget
RUN useradd --create-home --shell /bin/bash dv
RUN adduser dv sudo
RUN echo 'dv:changeme' | chpasswd
RUN echo "dv ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER dv
ENV USER=dv
WORKDIR /home/dv
COPY --chown=dv:dv . /home/dv/.files
RUN cd .files && chmod +x deploy.sh && ./deploy.sh
