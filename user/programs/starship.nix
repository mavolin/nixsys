{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      battery.disabled = true;
      character = let
        c = "€";
      in {
        success_symbol = "[${c}](bold green)";
        error_symbol = "[${c}](bold red)";
      };
      cmd_duration = {
        min_time = 3000;
        format = "took [$duration]($style) ";
      };
      directory = {
        truncation_length = 5;
        truncation_symbol = "•/";
        format = "[$path]($style)[$lock_symbol]($lock_style) ";
      };
      git_branch = {
        format = "[$symbol$branch]($style) ";
        style = "bold yellow";
      };
      git_status = {
        conflicted = "⚔️ ";
        ahead = "\${count}×a🙍 ";
        behind = "\${count}×🐝hind ";
        diverged = "🔱 \${ahead_count}×a🙍/\${behind_count}×🐝hind ";
        untracked = "\${count}×un🛤️ed ";
        stashed = "stashed ";
        modified = "\${count}×mod ";
        staged = "\${count}×stgd ";
        renamed = "\${count}×mv ";
        deleted = "\${count}×🚮 ";
        style = "bright-white";
        format = "$all_status$ahead_behind";
      };
      memory_usage = {
        format = "$symbol[\${ram}( | \${swap})]($style) ";
        threshold = 70;
        style = "bold dimmed white";
        disabled = false;
      };
      package.disabled = true;
    };
  };
}
