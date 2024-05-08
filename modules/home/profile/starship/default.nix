{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf (config.mistman.profile.enable) {
  programs.starship = {
    enableBashIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;

    settings = {
      add_newline = false;
      command_timeout = 300;

      format =
        "\\[$hostname\\] "
        + "$directory"
        + "$git_branch"
        + "\${custom.jujutsu}"
        + "\${custom.git_tracking}"
        + "$git_state"
        + " $cmd_duration"
        + "$line_break"
        + "$sudo"
        + "$jobs"
        + "$shell"
        + "$character";

      character = {
        format = "[$symbol ]($style)";
        success_symbol = "[](purple)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };
      cmd_duration = {
        format = "[$duration]($style)";
        style = "yellow";
      };

      directory = {
        style = "bright-blue";
        format = "([$read_only]($read_only_style))[$path]($style)";
      };

      git_branch = {
        format = "( [$branch(:$remote_branch)]($style))";
        style = "208";
        only_attached = true;
      };
      git_metrics = {
        format = "([|](dimmed white)[+$added]($added_style)[-$deleted]($deleted_style))";
        disabled = false;
        ignore_submodules = true;
      };
      git_state = {
        format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
        style = "bright-black";
      };
      git_status = {
        format = "([|](dimmed white)[$ahead$behind$conflicted$untracked$modified$staged$renamed$deleted$stashed]($style)) ";
        style = "219";
        conflicted = "";
        untracked = "";
        modified = "";
        staged = "";
        renamed = "";
        deleted = "";
        stashed = "≡";
        ignore_submodules = true;
      };

      hostname = {
        format = "[$hostname]($style)( $ssh_symbol)";
        ssh_only = false;
        ssh_symbol = "";
        # style = "bold dimmed white";
        style = "bold bright-black";
      };

      jobs = {
        format = "([$symbol$number]($style) )";
        number_threshold = 1;
        style = "bg:168";
        symbol = "華";
      };

      shell = {
        disabled = false;
        format = "[$indicator]($style)";
      };
      sudo = {
        disabled = false;
        format = "[$symbol]($style)";
        symbol = "✦ ";
        style = "yellow";
      };

      username = {
        format = "([$user]($style)@)";
        show_always = true;
        style_user = "bright-purple";
      };

      custom.git_tracking = {
        shell = ["${pkgs.bash}/bin/bash" "-c"];
        command = ''echo -e "$(git ls-files -dkmot --exclude-standard --deduplicate | jq -Rrsf ${./git_tracking.jq})"'';
        description = "short description of the counted *file* state in a git repo";
        when = true;
        require_repo = true;
        format = "([|](dimmed white)$output)";
      };

      custom.jujutsu = {
        shell = ["${pkgs.bash}/bin/bash" "-c"];
        command = let
          template = ''
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
        in "jj log --color always --no-pager -r @ --no-graph -T ${lib.escapeShellArg template}";
        description = "jujutsu-related information";
        when = "jj root";
        format = "([|](dimmed white)$output)";
      };
    };
  };
}
