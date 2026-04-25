{ inputs, ... }:
{
  imports = [
    #
    # ========== Required Configs ==========
    #
    (inputs.import-tree ./common/core)

    #
    # ========== Host-specific Optional Configs ==========
    #
    common/optional/browsers
    common/optional/media
    common/optional/social
    common/optional/tools
  ];
}
