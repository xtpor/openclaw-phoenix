# Project Overview: OpenClaw Phoenix

OpenClaw Phoenix is a Dockerized environment designed to run the **OpenClaw Gateway** with a robust, self-healing architecture using the **Nix package manager**. It ensures that the gateway environment remains functional even if its primary configuration (`shell.nix`) becomes corrupted.

### Main Technologies
- **Docker**: Containerization for consistent deployment.
- **Nix**: Used for deterministic dependency management and environment isolation.
- **Node.js (v22)**: The runtime for the OpenClaw application.
- **OpenClaw**: The core application, installed globally via npm.

### Architecture
The project follows a "phoenix" pattern (self-healing):
1.  **`Dockerfile`**: Builds a Nix-based image, installs Node.js 22, and the `openclaw` package globally.
2.  **`entrypoint.sh`**: The startup script that manages the environment. It attempts to load a `shell.nix` from the persistent workspace (`/root/.openclaw`).
3.  **`recovery.nix`**: A read-only, "guaranteed-to-work" Nix shell configuration. If the main `shell.nix` is missing or fails validation, the entrypoint falls back to this recovery shell to allow for debugging and repair.

---

## Building and Running

### Prerequisites
- Docker installed on your system.

### Build the Image
```bash
docker build -t openclaw-phoenix .
```

### Run the Container
To run the default OpenClaw gateway with persistent storage:
```bash
docker run -it -v openclaw_data:/root/.openclaw openclaw-phoenix
```

### Run with Custom Commands
You can override the default startup command (`npx openclaw gateway start`) by passing arguments to the container:
```bash
docker run -it -v openclaw_data:/root/.openclaw openclaw-phoenix openclaw --help
```

---

## Development Conventions

- **Workspace**: The primary workspace is located at `/root/.openclaw` inside the container. This should be mounted as a volume for persistence.
- **Environment Management**: Use `shell.nix` in the workspace to define additional dependencies or environment variables.
- **Recovery**: If the container boots into "RECOVERY MODE", it means the `shell.nix` in your workspace is invalid. The broken file is backed up as `broken_shell.nix.bak`.
- **Tools**: The recovery environment includes `git`, `curl`, `jq`, `sed`, `grep`, and `vim` for troubleshooting.
