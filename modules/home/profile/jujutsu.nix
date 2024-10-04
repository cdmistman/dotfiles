{ config, ... }:

{
  programs.jujutsu = {
    enable = true;

    settings = {
      core = {
        fsmonitor = "watchman";
        watchman.register_snapshot_trigger = true;
      };

      fix.tools = {
        cargo.command = [ "cargo" "fmt" ];
        eslint.command = [ "eslint" ];
        nixfmt.command = [ "nixpkgs-fmt" ];
      };

      git = {
        private-commits = ''present(TIP::) | present("wip:*")'';
        push-bookmark-prefix = "cad/working-";
      };

      revset-aliases = {
        stack = "ancestors(immutable()-..present(@), 1)";
        stacks = "ancestors(immutable()..bookmarks(), 2) | bookmarks()::";
      };

      revsets = {
        log = "stacks";
        short-prefixes = "stack";
      };

      template-aliases = {
        starship = ''
          concat(
            format_short_change_id_with_hidden_and_divergent_info(self),
            surround(" ", "", local_branches.join(" ")),
            surround(
              " ",
              "",
              parents.map(|parent| "~" ++ parent.local_branches().join(" ")).join(" "),
            ),
          )
        '';
      };

      ui = {
        always-allow-large-revsets = true;
        default-command = [ "log" "-r" "stack" ];
        diff.tool = [ "difft" "--color=always" "$left" "$right" ];
        editor = "cursor";
      };

      user = {
        email = config.programs.git.userEmail;
        name = config.programs.git.userName;
      };
    };
  };
}
