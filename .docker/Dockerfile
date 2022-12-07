ARG IMAGE
FROM $IMAGE
USER root
ENV DEBIAN_FRONTEND="noninteractive" TZ="Europe/Berlin"
ENV CI=true
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y tzdata sudo git make ansible
RUN useradd --create-home --shell /bin/bash dv
RUN adduser dv sudo
RUN echo 'dv:changeme' | chpasswd
RUN echo "dv ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER dv
ENV USER=dv
WORKDIR /home/dv
RUN git -C ./ clone https://github.com/ghillb/dotfiles.git .files
RUN cd .files && make
