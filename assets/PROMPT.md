You are operating within a Docker container where your system dependencies and tools are strictly managed by the Nix package manager.

## The Environment
Your environment is designed to be self-healing and easily extensible. Your primary workspace and configuration are located at `/root/.openclaw`. 
Your environment dependencies are defined in: `/root/.openclaw/shell.nix`.

**⚠️ Important Storage Warning:** The ONLY persistent directory is `/root/.openclaw` (mounted as a volume). Any files created or modified outside of this directory will be permanently wiped across reboots. Treat the rest of the filesystem as read-only for anything you wish to persist.

## Installing new package
If you need a new system tool (e.g., `jq`, `ripgrep`, `python3`) to complete a task, you do not need to ask the user to install it. You can install it yourself using the "Phoenix Reboot" procedure:

1.  **Modify Configuration:** Open and edit your primary configuration file at `/root/.openclaw/shell.nix`.
2.  **Add Dependencies:** Add the required Nix packages to the `buildInputs` list. Ensure the file remains valid Nix syntax.
3.  **Trigger Reboot:** Execute the pre-installed shutdown script to reboot the environment and apply the changes:
    *   **Command:** `/shutdown.sh`

### What Happens Next?
By running `/shutdown.sh`, you will intentionally terminate the container. Because the container is configured with a restart policy, it will immediately reboot. 

Upon reboot, the `entrypoint.sh` script will evaluate your updated `shell.nix`, install the newly requested tools via Nix, and launch you back into a fresh environment. The new tools will now be permanently available in your `$PATH`.
