{ pkgs, lib, ... }:

{
  # User account settings
  home.username = "km3to";
  home.homeDirectory = "/home/km3to";
  home.stateVersion = "25.05";

  # --- SINGLE, MERGED PACKAGE LIST ---
  home.packages = with pkgs; [
    neofetch
    brave
    noto-fonts
    dejavu_fonts
    wl-clipboard      # For Wayland copy/paste
    cliphist          # For clipboard history
    qgnomeplatform    # To make Qt apps use the GTK theme
    wofi
    waybar

    # Added for the Sway Ecosystem
    sway          # The window manager itself
    swaybg        # For setting wallpapers
    swaylock      # For locking the screen
    swayidle      # For idle management (e.g., lock after X minutes)
    wdisplays     # A graphical tool to manage monitor layouts
    
    # The portal for screen sharing, etc., on Sway/wlroots
    xdg-desktop-portal-wlr
  ];

  # --- SWAY CONFIGURATION ---
  wayland.windowManager.sway = {
    enable = true;
  };

  # --- DOTFILE MANAGEMENT ---
  xdg.configFile = {
    "sway/config".source = lib.mkForce ./sway/config;
    "waybar/config".source = ./waybar/config;
    "waybar/style.css".source = ./waybar/style.css;
    "wofi/style.css".source = ./wofi/style.css;
  };

  # --- XDG DESKTOP PORTAL ---
  # This section is managed here, alongside the window manager that needs it.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    config.common.default = "*";
  };

  # Set environment variables (for Qt theme)
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "gnome";
  };

  # --- PROGRAM CONFIGURATIONS ---
  programs.bash = {
    enable = true;
    # shellAliases = {
    #   nix-cleanup = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +5 && sudo nix-collect-garbage --delete-old";
    # };
  };

  programs.kitty = {
    enable = true;
    settings = {
      copy_on_select = "yes";
      font_size = "14.0";
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-suda
    ];

    # General Neovim settings
    extraConfig = ''
      set number
      set mouse=a

      " Configure suda.vim
      let g:suda_smart_edit = 1
    '';
  };

  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        vscode-icons-team.vscode-icons
        rust-lang.rust-analyzer
        jnoortheen.nix-ide
      ];
      userSettings = {
        "editor.fontSize" = 14;
        "workbench.colorTheme" = "Default Dark Modern";
	"workbench.iconTheme" = "vscode-icons";
      };
    };
  };

  # --- GTK & DESKTOP THEMING ---
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      "color-scheme" = "prefer-dark";
    };
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
