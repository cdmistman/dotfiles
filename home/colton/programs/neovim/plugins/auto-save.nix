{ inputs, pkgs, ... }:

{
  type = "lua";
  plugin = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "auto-save-nvim";
    src = inputs.auto-save-nvim;
  };
}

