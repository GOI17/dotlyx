# Use the official Ubuntu 22.04 base image
FROM ubuntu:22.04

# Set an argument for the username, so it's easily configurable
ARG USERNAME=devuser
ARG USER_UID=1000
ARG USER_GID=1000

# Set terminal environment variables for color support
ENV TERM=xterm-256color
ENV COLORTERM=truecolor

# Install base dependencies and create the user in a single layer
RUN apt-get update && \
    apt-get install -y curl build-essential sudo zsh && \
    rm -rf /var/lib/apt/lists/* && \
    # --- FIX: Remove the conflicting group from the base image ---
    groupdel nixbld && \
    # Create the user with a home directory
    groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m -s /bin/zsh $USERNAME && \
    # Give the user passwordless sudo privileges for convenience
    echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# Download the installation script
RUN curl -fsSL https://raw.githubusercontent.com/GOI17/dotlyx/HEAD/install -o /tmp/install.sh

# Default command: run installation script then start interactive zsh shell
CMD ["zsh", "-c", "bash -i < /tmp/install.sh; exec zsh"]
