#!/bin/bash

current_brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
max_brightness=$(cat /sys/class/backlight/intel_backlight/max_brightness)
step_size=$((max_brightness / 20))       # Set the step size to 5% (adjust as needed)
min_brightness=$step_size  # Set the minimum brightness level to 5% (adjust as needed)

case "$1" in
    --scroll-up)
        new_brightness=$((current_brightness + step_size))
        ;;
    --scroll-down)
        new_brightness=$((current_brightness - step_size))
        ;;
    *)
        new_brightness=$current_brightness
        ;;
esac

# Prevent brightness from going below the minimum level
if ((new_brightness < min_brightness)); then
    new_brightness=$min_brightness
fi

# Prevent brightness from exceeding the maximum level
if ((new_brightness > max_brightness)); then
    new_brightness=$max_brightness
fi

echo $new_brightness | tee /sys/class/backlight/intel_backlight/brightness > /dev/null

# Calculate the brightness percentage
percentage=$((new_brightness * 100 / max_brightness))

# Emit the brightness value and percentage
echo "$percentage;%percentage%"

