#!/usr/bin/env bash
set -xe

# Define configurable variables at the top
recording_dir=~/ScreenCapture
record_buffer=/tmp/screen-recording-buffer.mp4

error() {
    notify-send -u critical "Recording Error" "$1"
    exit 1
}

# Create the recording directory if it doesn't exist
if [ ! -d $recording_dir ]; then
    mkdir -p $recording_dir
fi

# Check if the recorder is already running
# If it is, stop the recording
pgrep -x ffmpeg && error "Previous recording still being processed. (from $record_buffer)"

# If the recorder is not running, start a new recording
pgrep -x wf-recorder && is_recording="yes" || is_recording="nop"

if [ $is_recording = "nop" ]; then
    # Clean up the previous recording buffer
    rm "$record_buffer" || echo "No previous recording buffer found"
    notify-send -u low "Starting to record" -t 200
    # Start recording
    wf-recorder \
        --audio="easyeffects_sink.monitor" \
        -g "$(slurp)" \
        -f "$record_buffer" \
        || error "Failed to start recording"
    exit
fi

# Stop the recording
pkill wf-recorder
notify-send -u low "Recording stopped" -t 3000

# Compress/Encode/Save the recording
dest="$recording_dir/$(date +"%FT%H%M").mp4"

# Got twice the speedup by using prime-run (experiment sample size: 1 lol)
#prime-run ffmpeg -i "$record_buffer" -vcodec libx265 -crf 28 "$dest"
ffmpeg -i "$record_buffer" -vcodec libx265 -crf 28 "$dest"

size=$(du -h "$dest" | awk '{print $1}')
notify-send -u normal "Recording saved" "$dest ($size)"
