{...}: {
  programs.zsh = {
    enable = true;
    autocd = true;
    history.size = 1000;
    
    profileExtra = "export PATH=$HOME/nixos-config/scripts:$PATH";
    shellAliases = {
      ls = "eza -l";
      la = "eza -la";
    };

    initContent = "nitch";
  };

  programs.eza = {
    enable               = true;
    enableZshIntegration = true;
    colors               = "always";
    icons                = "always";
    extraOptions         = ["--group-directories-first"];
  };
}