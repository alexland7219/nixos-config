{
  pkgs,
  ...
}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    extraPackages = [ pkgs.jj-starship ];
    
    settings = {
      # Disable git, use jj-starship
      git_branch.disabled  = true;
      git_commit.disabled  = true;
      git_state.disabled   = true;
      git_status.disabled  = true;
      git_metrics.disabled = true;
     
      custom.jj = {
        when   = "jj-starship detect";
        shell  = [ "jj-starship" ];
        format = "$output ";
      };

      directory = {
        truncation_length = 8;
        truncation_symbol = " ";
      };

      character = {
        success_symbol = "[](bold green) ";
        error_symbol   = "[](bold red) ";
      };

      battery.disabled = true;
    };
  };
}
