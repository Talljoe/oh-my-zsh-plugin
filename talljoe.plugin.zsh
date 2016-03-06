prompt_battery_lite() {
  # The battery can have four different states - default to 'unknown'.
  local current_state="unknown"
  typeset -AH battery_states
  battery_states=(
    'low'           'red'
    'charging'      'yellow'
    'charged'       'green'
    'disconnected'  "$DEFAULT_COLOR_INVERTED"
  )
  # Set default values if the user did not configure them
  set_default POWERLEVEL9K_BATTERY_LITE_LOW_THRESHOLD  10

  if [[ $OS =~ Linux ]]; then
    local sysp="/sys/class/power_supply"
    # Reported BAT0 or BAT1 depending on kernel version
    [[ -a $sysp/BAT0 ]] && local bat=$sysp/BAT0
    [[ -a $sysp/BAT1 ]] && local bat=$sysp/BAT1

    # Return if no battery found
    [[ -z $bat ]] && return

    [[ $(cat $bat/capacity) -gt 100 ]] && local bat_percent=100 || local bat_percent=$(cat $bat/capacity)
    [[ $(cat $sysp/AC/online) =~ 1 ]] && local connected=true
    [[ $(cat $bat/status) =~ Charging && $bat_percent =~ 100 ]] && current_state="charged"
    [[ $(cat $bat/status) =~ Charging && $bat_percent -lt 100 ]] && current_state="charging"
    [[ $(cat $bat/status) =~ Unknown ]] && current_state="charging"
    if [[ -z  $connected ]]; then
      [[ $bat_percent -lt $POWERLEVEL9K_BATTERY_LITE_LOW_THRESHOLD ]] && current_state="low" || current_state="disconnected"
    fi
    if [[ -f /usr/bin/acpi ]]; then
      local time_remaining=$(acpi | awk '{ print $5 }')
      if [[ $time_remaining =~ rate || $time_remaining =~ discharging ]]; then
        local tstring="..."
      elif [[ $time_remaining =~ "[:digit:]+" ]]; then
        local tstring=${(f)$(date -u -d "$(echo $time_remaining)" +%k:%M)}
      fi
    fi
    [[ -n $tstring ]] && local remain=" ($tstring)"
  fi

  local message
  # Default behavior: Be verbose!
  set_default POWERLEVEL9K_BATTERY_LITE_VERBOSE true
  if [[ "$POWERLEVEL9K_BATTERY_LITE_VERBOSE" == true ]]; then
    message="$remain"
    [[ -z $remain && $bat_percent -lt 100 ]] && message="$bat_percent%%"
  fi

  local icon="BATTERY_ICON"
  set_default POWERLEVEL9K_BATTERY_LITE_FORCE_ICON false
  if [[ -n $connected ]]; then
    [[ $current_state =~ charging || "$POWERLEVEL9K_BATTERY_LITE_FORCE_ICON" == true ]] && local icon="ROOT_ICON"
  fi

  # Draw the prompt_segment
  [[ -n $bat ]] && "$1_prompt_segment" "${0}_${current_state}" "$2" "$DEFAULT_COLOR" "${battery_states[$current_state]}" "$message" "$icon"
}

