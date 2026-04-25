FROM nixos/nix:latest

# 1. Tell npm exactly where to install global packages
ENV NPM_CONFIG_PREFIX="/root/.npm-global"

# 2. Add that directory to the system PATH so the container can find the 'openclaw' command
ENV PATH="/root/.npm-global/bin:$PATH"

# Install OpenClaw globally
RUN nix-env -iA nixpkgs.nodejs_22
RUN npm install -g openclaw

# Copy the recovery script to a read-only path
RUN mkdir -p /config
COPY recovery.nix /config/recovery.nix

# Copy the agent instructions to the root
COPY assets/PROMPT.md /PROMPT.md

# Copy and set up the entrypoint and shutdown scripts
COPY entrypoint.sh /entrypoint.sh
COPY shutdown.sh /shutdown.sh
RUN chmod +x /entrypoint.sh /shutdown.sh

# We don't define VOLUME for /nix here. We do it at runtime.
VOLUME ["/root/.openclaw"]

ENTRYPOINT ["/entrypoint.sh"]
