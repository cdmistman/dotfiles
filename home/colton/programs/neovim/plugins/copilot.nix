{ inputs, pkgs, ... }:

{
  type = "lua";
  plugin = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "copilot-vim";
    src = inputs.copilot-vim;
  };
}

