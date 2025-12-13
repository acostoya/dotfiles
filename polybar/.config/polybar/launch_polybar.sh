killall polybar 2>/dev/null

if type "xrandr" >/dev/null 2>&1; then
  for m in $(xrandr --query | grep " connected" | grep -v " disconnected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload --config=$HOME/.config/polybar/config.ini toph &
  done
else
  polybar --reload --config=$HOME/.config/polybar/config.ini toph &
fi

wait
