# Single source for every distro variant.
# Select the base with --build-arg BASE_IMAGE=... (compose passes this per service).
ARG BASE_IMAGE=ubuntu:22.04
FROM ${BASE_IMAGE}

ARG USERNAME=chatreejs
ARG TIMEZONE="Asia/Bangkok"
ARG DEBIAN_FRONTEND=noninteractive

ENV DOCKERIZED=true
ENV USER=${USERNAME}

# Setup timezone and install linux deps
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo ${TIMEZONE} > /etc/timezone \
    && apt-get update && apt-get install -y sudo curl git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create user and add to sudoers
RUN useradd -m ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Use user
USER ${USERNAME}
ENV USER_HOME=/home/${USERNAME}
WORKDIR ${USER_HOME}

# Copy dotfiles and run the installer
COPY --chown=${USERNAME}:${USERNAME} . ${USER_HOME}/dotfiles
RUN cd ${USER_HOME}/dotfiles \
    && ./install.sh

CMD ["/bin/zsh"]
