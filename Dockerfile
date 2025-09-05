FROM ubuntu:22.04

# Install basic dependencies
RUN apt-get update && apt-get install -y curl git python3 build-essential sudo zsh

# Install Nix
RUN curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux --init none --no-confirm

# Set up Nix environment
ENV PATH="/nix/var/nix/profiles/default/bin:$PATH"
ENV HOME=/root

# Copy project files
COPY . /app
WORKDIR /app

# Make install executable
RUN chmod +x install

# Run install at container start
CMD ["bash", "install", "-i"]