#!/usr/bin/env bash

# Polybar colored status script
# Produces icon + text with the same severity color.

COLOR_GREEN="#43a047"
COLOR_YELLOW="#fdd835"
COLOR_ORANGE="#E57C46"
COLOR_RED="#FF5250"
COLOR_FG="#f5f5f5"

CPU_STATE="/tmp/polybar_cpu_state"
TEMP_SOURCE="$HOME/.config/coretem"

usage_color() {
  local p=${1:-0}
  (( p < 0 )) && p=0
  (( p > 100 )) && p=100
  if (( p <= 50 )); then
    echo "$COLOR_GREEN"
  elif (( p <= 70 )); then
    echo "$COLOR_YELLOW"
  elif (( p <= 85 )); then
    echo "$COLOR_ORANGE"
  else
    echo "$COLOR_RED"
  fi
}

temp_color() {
  local t=${1:-0}
  if (( t <= 50 )); then
    echo "$COLOR_GREEN"
  elif (( t <= 70 )); then
    echo "$COLOR_YELLOW"
  elif (( t <= 85 )); then
    echo "$COLOR_ORANGE"
  else
    echo "$COLOR_RED"
  fi
}

print_cpu() {
  local cpu_line
  cpu_line=$(grep -m1 '^cpu ' /proc/stat) || { echo ""; return; }
  # cpu user nice system idle iowait irq softirq steal guest guest_nice
  read -r _ user nice system idle iowait irq softirq steal _ _ <<< "$cpu_line"
  local idle_all=$((idle + iowait))
  local non_idle=$((user + nice + system + irq + softirq + steal))
  local total=$((idle_all + non_idle))

  local prev_idle prev_total
  if [[ -f "$CPU_STATE" ]]; then
    read -r prev_idle prev_total < "$CPU_STATE"
  else
    prev_idle=$idle_all
    prev_total=$total
  fi
  echo "$idle_all $total" > "$CPU_STATE"

  local totald=$((total - prev_total))
  local idled=$((idle_all - prev_idle))
  local usage=0
  if (( totald > 0 )); then
    usage=$(( (100 * (totald - idled)) / totald ))
  fi

  local color
  color=$(usage_color "$usage")
  echo "%{F$color} ${usage}%%%{F-}"
}

print_mem() {
  local total used
  read -r _ total used _ < <(free -m | awk '/^Mem:/ {print "mem", $2, $3, $4}') || { echo ""; return; }
  if [[ -z "$total" || "$total" -eq 0 ]]; then
    echo ""
    return
  fi
  local perc=$(( used * 100 / total ))
  local color
  color=$(usage_color "$perc")
  echo "%{F$color} ${used}M%{F-}"
}

print_fs() {
  local total used perc
  read -r total used perc < <(df -P -h / | awk 'NR==2 {gsub("%","",$5); print $2, $3, $5}') || { echo ""; return; }
  perc=${perc:-0}
  local color
  color=$(usage_color "$perc")
  echo "%{F$color} ${used}/${total}%{F-}"
}

print_temp() {
  local raw
  raw=$(cat "$TEMP_SOURCE" 2>/dev/null || echo 0)
  [[ -z "$raw" ]] && raw=0
  local t
  if (( raw > 1000 )); then
    t=$(( raw / 1000 ))
  else
    t=$raw
  fi
  local color
  color=$(temp_color "$t")
  echo "%{F$color} ${t}°C%{F-}"
}

print_fsbar() {
  local perc
  perc=$(df -P / | awk 'NR==2 {gsub("%","",$5); print $5}') || { echo ""; return; }
  perc=${perc:-0}
  local color filled empty i
  color=$(usage_color "$perc")
  local glyph=$'\uFB73'
  local width=6
  filled=$(( (perc * width + 50) / 100 ))
  (( filled > width )) && filled=$width
  (( filled < 0 )) && filled=0
  empty=$(( width - filled ))
  local bar_fill="" bar_empty=""
  for ((i=0;i<filled;i++)); do bar_fill+="$glyph"; done
  for ((i=0;i<empty;i++)); do bar_empty+="$glyph"; done
  echo "%{F$color}%{T4}${bar_fill}%{F#33f5f5f5}${bar_empty}%{F$color}%{T-} ${perc}%%%{F-}"
}

print_mic() {
  if ! command -v pactl >/dev/null 2>&1; then
    echo ""
    return
  fi

  local source
  source=$(pactl info 2>/dev/null | awk -F': ' '/Default Source/ {print $2}')
  [[ -z "$source" ]] && source="@DEFAULT_SOURCE@"

  local mute
  mute=$(pactl get-source-mute "$source" 2>/dev/null | awk '{print $2}')
  if [[ "$mute" == "yes" ]]; then
    echo "%{F$COLOR_RED} Muted%{F-}"
    return
  fi

  local vol
  vol=$(pactl get-source-volume "$source" 2>/dev/null | awk 'NR==1{for(i=1;i<=NF;i++) if ($i ~ /%$/){gsub("%","",$i); print $i; exit}}')
  [[ -z "$vol" ]] && vol=0
  (( vol < 0 )) && vol=0
  (( vol > 100 )) && vol=100

  local color
  color=$(usage_color "$vol")
  echo "%{F$color} ${vol}%%%{F-}"
}

print_vol() {
  if ! command -v pactl >/dev/null 2>&1; then
    echo ""
    return
  fi

  local sink
  sink=$(pactl info 2>/dev/null | awk -F': ' '/Default Sink/ {print $2}')
  [[ -z "$sink" ]] && sink="@DEFAULT_SINK@"

  local mute
  mute=$(pactl get-sink-mute "$sink" 2>/dev/null | awk '{print $2}')
  if [[ "$mute" == "yes" ]]; then
    echo "%{F$COLOR_FG} Muted%{F-}"
    return
  fi

  local vol
  vol=$(pactl get-sink-volume "$sink" 2>/dev/null | awk 'NR==1{for(i=1;i<=NF;i++) if ($i ~ /%$/){gsub("%","",$i); print $i; exit}}')
  [[ -z "$vol" ]] && vol=0
  (( vol < 0 )) && vol=0
  (( vol > 100 )) && vol=100

  local color
  color=$(usage_color "$vol")
  echo "%{F$color} ${vol}%%%{F-}"
}

case "$1" in
  cpu)    print_cpu ;;
  mem)    print_mem ;;
  fs)     print_fs ;;
  fsbar)  print_fsbar ;;
  temp)   print_temp ;;
  vol)    print_vol ;;
  mic)    print_mic ;;
  *)      echo "" ;;
esac

