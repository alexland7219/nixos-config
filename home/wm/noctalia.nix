{ inputs, config, unstablePkgs, ... }: 

{
  # programs.noctalia only available on HM 26.11+ (unstable)
  imports = [
    "${inputs.home-manager-unstable}/modules/programs/noctalia/default.nix"
  ];
  
  programs.noctalia = {
    enable = true;
    package = unstablePkgs.noctalia;
    checkConfig = true;

    settings = {
      # Enable backdrop for wallpaper
      backdrop.enabled = true;

      # Noctalia bar
      bar.default = {
        # Customization
        background_opacity = 0;
        capsule_radius = 4;
        compositor_blur = false;
        font_weight = 500;
        margin_ends = 0;
        radius = 0;
        scale = 1.1;
        shadow = false;
        thickness = 28;
        
        # Layout
        start  = [
          "session" 
          "workspaces"
        ];
        center = [ 
          "date" 
        ];
        end = [
          "tray"
          "weather"
          "volume"
          "network"
          "bluetooth"
          "brightness"
          "battery"
          "notifications"
          "clock"
        ];
      };

      # Control center
      control_center.width = 730;
      location.address = "Brussels, Belgium";
      
      # Widgets
      widget = {
        workspaces = {
          show_labels = false;
          pill_scale = 0.9;
        };
        date.format = "{:%A, %d %B}";
        clock.format = "{:%H %M %Z}";
      };

      # Shell
      shell = {
        avatar_path = "${config.home.homeDirectory}/.face";
        font_family = "Inter";
      };

      # Other settings
      desktop_widgets.enabled = false;
      lockscreen_widgets.enabled = false;
      nightlight.enabled = true;
      notification.history_retention_hours = 6;
      
      # Themes and wallpaper
      theme = {
        builtin = "Tokyo-Night";
        community = "Catppuccin Macchiato Blue";
        mode = "dark";
        source = "builtin";
        
        # Theme templates
        templates.builtin_ids = [ "alacritty" "gtk4" "niri" "qt" ];

        # Wallpaper
        wallpaper.default.path = "${config.home.homeDirectory}/Pictures/Wallpapers/Snow-Capped Mountain.jpg";
      };
    };
  };
}