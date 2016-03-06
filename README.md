# Talljoe's Oh My ZSH plugin

## powerlevel9k Battery Lite

A simpler battery meter.  Displays an icon to differentiate between AC and BATTERY power. Displays time remaining when discharging and battery percentage when charging. When fully charged the segment is hidden (can be forced to display).

Add to your prompt segment:

    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status battery_lite time)

### Options

    POWERLEVEL9K_BATTERY_LITE_VERBOSE=true

When true displays text; when false just shows the icon.

    POWERLEVEL9K_BATTERY_LITE_LOW_{ITEM}="red"
    POWERLEVEL9K_BATTERY_LITE_CHARGING_{ITEM}="cyan"
    POWERLEVEL9K_BATTERY_LITE_CHARGED_{ITEM}="green"
    POWERLEVEL9K_BATTERY_LITE_DISCONNECTED_{ITEM}="yellow"

Overrides the colors for various parts of the prompt. `ITEM` can be `VISUAL_IDENTIFIER_COLOR`, `FOREGROUND`, or `BACKGROUND`.

    POWERLEVEL9K_AC_ICON=$'\uF201'

The icon to use when charging. Defaults to the same as `ROOT_ICON`.

    POWERLEVEL9K_BATTERY_LITE_LOW_THRESHOLD=10

The battery percentage considered "low."