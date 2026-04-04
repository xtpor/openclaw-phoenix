# /config/recovery.nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  # These are the absolute minimum dependencies to keep the agent alive and fix things
  buildInputs = with pkgs; [
    git           # Required: To revert bad changes in the workspace
    curl          # Essential: For web requests / API calls
    jq            # Essential: For JSON parsing in terminal
    gnused        # Essential: For text manipulation
    gnugrep       # Essential: For searching logs
    vim
  ];

  shellHook = ''
    # Ensure npm global bin is in the path so `openclaw gateway start` works
    export PATH="$PATH:$(npm config get prefix)/bin"
  '';
}