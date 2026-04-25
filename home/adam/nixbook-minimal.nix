{ inputs, ... }:
{
  imports = [
    # ========== Required Configs ==========
    (inputs.import-tree ./common/core)
    # ========== Host-specific Optional Configs ==========
    common/optional/tools/default.nix
  ];
}
