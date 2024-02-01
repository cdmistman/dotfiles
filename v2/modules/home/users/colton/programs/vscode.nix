{config, lib, ...}:

let
  cfg = config.mistman.users.colton;
in

lib.mkIf cfg.enable {
  programs.vscode.enable = cfg.gui;
}
