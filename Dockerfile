# Use the official Ubuntu 22.04 base image
FROM ubuntu:22.04

# Set terminal environment variables for color support
ENV TERM=xterm-256color
ENV COLORTERM=truecolor

# Ensure the nixbld group exists before installing nix
RUN groupadd -r nixbld || true

# Install required packages
RUN apt-get update && \
    apt-get install -y build-essential sudo && \
    rm -rf /var/lib/apt/lists/*

# Default command: run installation script then start interactive zsh shell
CMD ["zsh", "-c", "curl -fsSL https://raw.githubusercontent.com/GOI17/dotlyx/HEAD/install | bash -i; exec zsh"]
