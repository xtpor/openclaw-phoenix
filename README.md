# OpenClaw Phoenix

openclaw + nix + docker

# Get Started

1. Start the container

```
docker run -d --restart=always \
    --name openclaw-phoenix \
    -v oc-workspace:/root/.openclaw \
    -v oc-nix:/nix \
    tintinho/openclaw-phoenix:9b70f39
```

2. Run the onboarding process 

```
docker exec openclaw-phoenix openclaw onboard
```

3. Do the pairing process (if you are using telegram)

```
openclaw pairing approve telegram 55LAP7FR
```

4. Add the special prompt teach the agent about this particular container

```
docker exec openclaw-phoenix sh -c "cat /PROMPT.md >> /root/.openclaw/workspace/AGENTS.md"
```