#!/usr/bin/env bash

# Polybar weather module.
# Location is auto-detected from your public IP by wttr.in (no API key needed).
# To force a fixed location, set WEATHER_LOCATION below, e.g.:
#   WEATHER_LOCATION="London"
#   WEATHER_LOCATION="Kuala Lumpur"
WEATHER_LOCATION=""

CACHE="/tmp/polybar_weather"
CACHE_TTL=900

ICON_CLEAR=""
ICON_MOON=""
ICON_PARTLY=""
ICON_CLOUD=""
ICON_RAIN=""
ICON_SNOW=""
ICON_BOLT=""
ICON_FOG=""
ICON_UNKNOWN=""

COLOR_YELLOW="#fdd835"
COLOR_BLUE="#42A5F5"
COLOR_CYAN="#4DD0E1"
COLOR_GRAY="#9E9E9E"
COLOR_RED="#FF5250"
COLOR_FG="#f5f5f5"

if [[ -f "$CACHE" ]]; then
  age=$(( $(date +%s) - $(stat -c %Y "$CACHE") ))
  if (( age < CACHE_TTL )); then
    cat "$CACHE"
    exit 0
  fi
fi

loc="${WEATHER_LOCATION:+$WEATHER_LOCATION/}"
data=$(curl -s --max-time 8 "wttr.in/${loc}?format=%C|%t|%l")
[[ -z "$data" ]] && exit 0

IFS='|' read -r cond temp locname <<< "$data"

case "${cond,,}" in
  *thunder*|*storm*)        icon=$ICON_BOLT;   color=$COLOR_RED ;;
  *snow*|*sleet*|*ice*)     icon=$ICON_SNOW;   color=$COLOR_CYAN ;;
  *partly*)                 icon=$ICON_PARTLY; color=$COLOR_CYAN ;;
  *rain*|*drizzle*|*shower*) icon=$ICON_RAIN;  color=$COLOR_BLUE ;;
  *fog*|*haze*|*mist*)      icon=$ICON_FOG;    color=$COLOR_GRAY ;;
  *cloudy*|*overcast*)      icon=$ICON_CLOUD;  color=$COLOR_GRAY ;;
  *sunny*|*clear*|*sun*)
    hour=$(date +%-H)
    if (( hour < 6 || hour >= 19 )); then
      icon=$ICON_MOON
    else
      icon=$ICON_CLEAR
    fi
    color=$COLOR_YELLOW ;;
  *)                        icon=$ICON_UNKNOWN; color=$COLOR_FG ;;
esac

echo "%{F$color}${icon} ${temp}%{F-}" > "$CACHE"
cat "$CACHE"