{ ... }:
{
  imports = [
    # ========== Required Configs ==========
    common/core
    # ========== Host-specific Optional Configs ==========
    common/optional/tools/default.nix
  ];
}
