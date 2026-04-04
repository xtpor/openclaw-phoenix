FROM nixos/nix:latest

# Install OpenClaw globally
RUN nix-env -iA nixpkgs.nodejs_22
RUN npm install -g openclaw

# Copy the recovery script to a read-only path
RUN mkdir -p /config
COPY recovery.nix /config/recovery.nix

# Copy and set up the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# We don't define VOLUME for /nix here. We do it at runtime.
VOLUME ["/root/.openclaw"]

ENTRYPOINT ["/entrypoint.sh"]
