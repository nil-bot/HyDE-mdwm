#!/bin/bash

mkdir -p ~/scripts

# Get the list of connected displays
displays=$(xrandr --listmonitors | awk 'NR>1 {print $4}')

# Check if there's only one display
if [ $(echo "$displays" | wc -w) -eq 1 ]; then
  echo "Only one display is connected. No need to set wallpaper for a specific display."
  exit 0
fi

echo "Available displays:"
select display in $displays; do
  if [ -n "$display" ]; then
    echo "You selected display: $display"
    break
  else
    echo "Invalid selection, try again."
  fi
done

# List available themes from ~/.config/hyde/themes/ using find for better handling of spaces
theme_dir="$HOME/.config/hyde/themes"
echo "Available themes:"

# Gather the theme directories and ensure they are handled correctly
themes=()
counter=1
while IFS= read -r theme; do
  themes+=("$theme")
  theme_name=$(basename "$theme")
  echo "$counter) $theme_name"
  ((counter++))
done < <(find "$theme_dir" -mindepth 1 -maxdepth 1 -type d | sort)  # Sorting the themes alphabetically

echo "Please select a theme folder:"
read -r theme_choice

# Get the user's theme choice
if [ "$theme_choice" -gt 0 ] && [ "$theme_choice" -lt "$counter" ]; then
  # Get the theme directory from the list
  selected_theme="${themes[$((theme_choice - 1))]}"
  selected_theme_name=$(basename "$selected_theme")
  echo "You selected theme: $selected_theme_name"

  # List wallpapers inside the chosen theme's wallpapers folder
  wallpaper_dir="$selected_theme/wallpapers"
  
  if [ ! -d "$wallpaper_dir" ]; then
    echo "No wallpapers directory found in this theme. Exiting."
    exit 1
  fi

  echo "Available wallpapers:"
  wallpapers=($(ls "$wallpaper_dir"))
  counter=1
  for wallpaper in "${wallpapers[@]}"; do
    echo "$counter) $wallpaper"
    ((counter++))
  done
  
  echo "Please select a wallpaper by number (or paste a custom path):"
  read -r wallpaper_choice

  # Handle selection of wallpaper from the list
  if [ "$wallpaper_choice" -gt 0 ] && [ "$wallpaper_choice" -lt "$counter" ]; then
    selected_wallpaper="${wallpapers[$((wallpaper_choice - 1))]}"
    wallpaper_path="$wallpaper_dir/$selected_wallpaper"
    echo "You selected wallpaper: $wallpaper_path"
  elif [ -n "$wallpaper_choice" ]; then
    # If the user pasted a path, check if it's a valid file
    wallpaper_path="$wallpaper_choice"
    
    # Suppress any errors that might occur during file check
    if [ ! -f "$wallpaper_path" ]; then
      echo "The file doesn't exist at the provided path: $wallpaper_path. Exiting."
      exit 1
    fi

    # Copy the custom wallpaper to the theme's wallpaper directory
    cp "$wallpaper_path" "$wallpaper_dir" 2>/dev/null
    echo "Custom wallpaper copied to $wallpaper_dir"
  else
    echo "Invalid selection, please try again."
    exit 1
  fi
else
  echo "Invalid selection, please try again."
  exit 1
fi

# Escape spaces for use in command line
escaped_path="$wallpaper_path"
escaped_display="$display"

# Create a script to set the wallpaper
script_path=~/scripts/set-wallpaper.sh

echo "#!/bin/bash" > "$script_path"
echo "swww img \"$escaped_path\" -o \"$escaped_display\"" >> "$script_path"

chmod +x "$script_path"

"$script_path"

echo "Wallpaper set successfully via $script_path"
