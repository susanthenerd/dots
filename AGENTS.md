# NixOS Configuration Agents Guide

## Build/Test Commands
- Build configuration: `nixos-rebuild build --flake .#framework` or `.#vps`
- Test configuration: `nixos-rebuild test --flake .#framework`
- Deploy to VPS: `nix run .#deploy.nodes.vps`
- Update flake: `nix flake update`

## Code Style Guidelines
- Use Nix functional style with explicit parameter lists: `{ config, lib, pkgs, ... }:`
- Follow existing module structure in modules/ directory
- Use 2-space indentation consistently
- Prefer attribute sets over let bindings where possible
- Use descriptive variable names and follow existing naming patterns
- Import modules using relative paths: `./modules/home`
- Use overlays for package customization in overlays/ directory
- Follow flake-parts structure for multi-system configurations