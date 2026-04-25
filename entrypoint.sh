#!/root/.nix-profile/bin/bash

WORKSPACE="/root/.openclaw"
MAIN_SHELL="$WORKSPACE/shell.nix"
RECOVERY_SHELL="/config/recovery.nix" # Read-only fallback

# Use provided arguments or default to 'openclaw gateway start'
CMD="$@"
if [ -z "$CMD" ]; then
    CMD="npx openclaw gateway run --allow-unconfigured"
fi

# 1. Check if I have created a shell.nix
if [ ! -f "$MAIN_SHELL" ]; then
    echo "No shell.nix found in workspace. Copying recovery template..."
    cp "$RECOVERY_SHELL" "$MAIN_SHELL"
fi

# 2. Attempt to evaluate the main shell.nix
echo "Testing main shell.nix..."
if nix-instantiate "$MAIN_SHELL" > /dev/null 2>&1; then
    echo "shell.nix is valid. Booting..."
    exec nix-shell "$MAIN_SHELL" --run "exec $CMD"
else
    echo "WARNING: shell.nix is corrupted or invalid!"
    echo "Falling back to recovery.nix..."
    echo "=========================================="
    echo "🚨 AGENT BOOTED IN RECOVERY MODE 🚨"
    echo "Node Version: $(node -v)"
    echo "Workspace: /root/.openclaw"
    echo "=========================================="

    # Rename the broken file so I can debug it later
    mv "$MAIN_SHELL" "$WORKSPACE/broken_shell.nix.bak"
    # Copy fresh recovery
    cp "$RECOVERY_SHELL" "$MAIN_SHELL"

    # Boot using the guaranteed recovery shell
    exec nix-shell "$RECOVERY_SHELL" --run "exec $CMD"
fi
