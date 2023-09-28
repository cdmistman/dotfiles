{ inputs, pkgs, ... }:

{
  type = "lua";
  plugin = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "which-key-nvim";
    src = inputs.which-key-nvim;
  };

  config = ''
    require("which-key").setup()
  '';
}

