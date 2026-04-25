#!/root/.nix-profile/bin/bash
# shutdown.sh - Used to terminate the gateway and trigger a Phoenix reboot

echo "Searching for OpenClaw gateway processes..."

# Find PIDs for processes matching 'openclaw' or 'node' running the gateway
# The [o] syntax is a trick to avoid matching the grep process itself
PIDS=$(ps -ef | grep '[o]penclaw' | awk '{print $2}')

if [ -n "$PIDS" ]; then
    echo "Terminating OpenClaw processes: $PIDS"
    kill -9 $PIDS
else
    echo "No specific OpenClaw processes found."
fi

# To ensure the Docker container actually exits (triggering a restart),
# we send a SIGKILL to PID 1.
echo "Triggering container exit (PID 1)..."
kill -9 1
