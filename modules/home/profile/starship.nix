{ config, lib, ... }: lib.mkIf (config.mistman.profile.enable) {
  programs.starship = {
    enableBashIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;

    settings = {
      add_newline = false;
      command_timeout = 300;

      format =
        "(\\[$username$hostname\\] )"
        + "$directory"
        + "$git_branch"
        + "$git_metrics"
        + "$git_state"
        + "$git_status"
        + "$cmd_duration"
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
        format = "[$duration]($style) ";
        style = "yellow";
      };

      directory = {
        style = "bright-blue";
      };

      git_branch = {
        format = "[$branch(:$remote_branch)]($style)";
        style = "208";
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
        style = "bright-black";
      };

      jobs = {
        format = "([$number]($style) )";
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
        style = "224";
      };

      username = {
        format = "([$user]($style)@)";
        show_always = true;
        style_user = "bright-purple";
      };
    };
  };
}
