ARG IMAGE
FROM $IMAGE
USER root
RUN apt-get update && apt-get upgrade -y && DEBIAN_FRONTEND="noninteractive" TZ="Europe/Berlin" apt-get install -y sudo git tzdata
RUN useradd --create-home --shell /bin/bash dv
RUN adduser dv sudo
RUN echo 'dv:changeme' | chpasswd
RUN echo "dv ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER dv
ENV USER=dv
WORKDIR /home/dv
RUN git -C ./ clone https://github.com/ghillb/dotfiles.git .files
RUN noninteractive=true ./.files/shell/deploy.sh
RUN curl -fsSL https://get.docker.com | sudo sh
RUN sudo usermod -aG docker $USER && newgrp docker
