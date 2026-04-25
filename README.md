# OpenClaw Phoenix

openclaw + nix

# Get Started

```
docker run -d --restart=always \
    --name openclaw-phoenix \
    -v oc-workspace:/root/.openclaw \
    -v oc-nix:/nix \

docker exec openclaw-phoenix cat 
docker exec op sh -c "cat /PROMPT.md >> /root/.openclaw/workspace/AGENTS.md"
```