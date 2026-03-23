# Langages et outils de développement
{ pkgs, ... }:
{
  home-manager.users.vincent.home.packages = with pkgs; [
    # Node.js + pnpm
    nodejs
    nodePackages.pnpm

    # Python
    python3

    # Rust (rustc, cargo, rustfmt, clippy)
    rustup

    # PHP
    php

    # Bases de données (clients)
    postgresql
    sqlite

    # Claude CLI
    claude-code
  ];
}
