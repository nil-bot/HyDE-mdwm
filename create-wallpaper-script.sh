#!/bin/bash

mkdir -p ~/scripts

echo "Available displays:"
displays=$(xrandr --listmonitors | awk 'NR>1 {print $4}')

if [ -z "$displays" ]; then
  echo "No displays found!"
  exit 1
fi

select display in $displays; do
  if [ -n "$display" ]; then
    echo "You selected display: $display"
    break
  else
    echo "Invalid selection, try again."
  fi
done

echo "Please enter the path to the wallpaper you want to set:"
read wallpaper_path

if [ ! -f "$wallpaper_path" ]; then
  echo "Wallpaper file does not exist at: $wallpaper_path"
  exit 1
fi

escaped_path=$(echo "$wallpaper_path" | sed 's/ /\\ /g')

escaped_display=$(echo "$display" | sed 's/ /\\ /g')

script_path=~/scripts/set-wallpaper.sh

echo "#!/bin/bash" > "$script_path"
echo "swww img $escaped_path -o $escaped_display" >> "$script_path"

chmod +x "$script_path"

"$script_path"

echo "Wallpaper set successfully via $script_path"

