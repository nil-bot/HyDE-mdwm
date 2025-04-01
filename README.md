# HyDE mdwm (multi display wallpaper manager)
A script designed to address one of my personal biggest annoyances with the HyDE project: the inability to set a separate wallpaper per display.

## Features
Set different wallpapers for each connected display.
Simple setup and usage.

## Instructions
1. ### Clone the repository
   `git clone https://github.com/nil-bot/HyDE-mdwm.git`
2. ### Move the script to your ~/scripts directory:
   `mv HyDE-mdwm/create-wallpaper-script.sh ~/scripts/create-wallpaper-script.sh`
4. ### Make the script executable:
   `chmod +x ~/scripts/create-wallpaper-script.sh`
6. ### Update Hyprland configuration:
   Open your Hyprland user preferences file:
   `nano ~/.config/hypr/userprefs.json`
   Add the following line to the end of the file:
   `exec-once: ~/scripts/set-wallpaper.sh`
8. ### Run the script:
   `~/scripts/create-wallpaper-script.sh`
