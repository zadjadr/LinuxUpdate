ARG VARIANT="latest"
FROM archlinux:${VARIANT}

ARG USERNAME=vscode
ARG PASSWORD=vscode

RUN pacman -Sy sudo git pacman-contrib --noconfirm && \
    useradd --create-home ${USERNAME} && \
    echo "${USERNAME}:${PASSWORD}" | chpasswd && \
    usermod --append --groups wheel ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL:ALL) ALL" >> /etc/sudoers && \
    locale-gen