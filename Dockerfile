# Use the official Ubuntu 22.04 base image
FROM ubuntu:22.04

# Set terminal environment variables for color support
ENV TERM=xterm-256color
ENV COLORTERM=truecolor

# Install required packages
RUN apt-get update && \
    apt-get install -y curl build-essential sudo && \
    rm -rf /var/lib/apt/lists/*

# Run the Dotlyx installation script as root
RUN curl -fsSL https://raw.githubusercontent.com/GOI17/dotlyx/HEAD/install | bash -i

# Default command: start an interactive zsh shell
CMD ["zsh"]
