#!/usr/bin/env bash

########################
### Variables Starts ###
########################

videodir="$HOME/Videos/"
audiodir="$HOME/Music/recodedAudios/"
recordingresolution="1366x768"
outputresolution="1366x768"
fps="30"
crf="18"

#monitoraudioinput="alsa_output.pci-0000_00_1f.3.analog-stereo.monitor"
monitoraudioinput="alsa_output.pci-0000_00_0e.0.analog-stereo.monitor"
#microphoneaudioinput="alsa_input.pci-0000_00_1f.3.analog-stereo"
microphoneaudioinput="alsa_input.pci-0000_00_0e.0.analog-stereo"
monitoraudiochannel="2"
microphoneaudiochannel="2"
monitoraudiofrequency="48000"
microphoneaudiofrequency="44100"
outputaudiofrequency="44100"


checkAudioDir(){
if [ ! -d "$audiodir" ]; then
    mkdir -p "$audiodir"
fi
}

internalAudioOnly(){
	ffmpeg \
		-f pulse -ac "$monitoraudiochannel" -ar "$monitoraudiofrequency" -i "$monitoraudioinput" \
		-acodec libmp3lame -ar "$outputaudiofrequency" -q:a 1 \
        "$(date +ffmpeg-"%Y-%m-%d-%I-%M-%S-%p").wav" #| xclip -selection c -t audio/x-wav
}

microphoneOnly(){
    ffmpeg \
        -f pulse -ac "$microphoneaudiochannel" -ar "$microphoneaudiofrequency" -i "$microphoneaudioinput" \
        -acodec libmp3lame -ar "$outputaudiofrequency" -q:a 1 \
            "$(date +ffmpeg-"Microphone-%Y-%m-%d-%I-%M-%S-%p").wav"
}

videoWithInternalAudio(){
    ffmpeg \
        -f pulse -ac "$monitoraudiochannel" -ar "$monitoraudiofrequency" -i "$monitoraudioinput" \
		-f x11grab -r "$fps" -s "$recordingresolution" -i :0.0+0,0 \
		-vcodec libx264 -preset veryfast -crf "$crf" \
		-acodec libmp3lame -ar "$outputaudiofrequency" -q:a 1 \
		-pix_fmt yuv420p \
        -s "$outputresolution" "$(date +ffmpeg-"%Y-%m-%d-%I-%M-%S-%p").mkv"
}

videoWithMicrophone(){
    ffmpeg \
		-f pulse -ac "$microphoneaudiochannel" -ar "$microphoneaudiofrequency" -i "$microphoneaudioinput" \
		-f x11grab -r "$fps" -s "$recordingresolution" -i :0.0+0,0 \
		-vcodec libx264 -preset veryfast -crf "$crf" \
		-acodec libmp3lame -ar "$outputaudiofrequency" -q:a 1 \
		-pix_fmt yuv420p \
        -s "$outputresolution" "$(date +ffmpeg-"%Y-%m-%d-%I-%M-%S-%p").mkv"
}

case $1 in
    InternalAudio)
      dunstify "InternalAudio Recording" --icon=dialog-information
      checkAudioDir
      cd "$audiodir"
      internalAudioOnly
      kitty -e lf $audiodir
    ;;
    MicrophoneOnly)
      dunstify "Microphone Recording" --icon=dialog-information
      checkAudioDir
      cd "$audiodir"
      microphoneOnly
    ;;
    VideoWithInternalAudio)
      dunstify "Start Capture Internal Audio" --icon=dialog-information
      checkVideoDir
      cd "$videodir"
      videoWithInternalAudio
    ;;
    VideoWithMic)
      dunstify "Start Capture with mic" --icon=dialog-information
      checkVideoDir
      cd "$videodir"
      videoWithMicrophone
    ;;
    shot)
      maim -s | xclip -selection clipboard -t image/png; xclip -selection clipboard -t image/png -o > $HOME/Pictures/screenshot-$(date -u +'%Y%m%d-%H%M%SZ')-selected.png
      dunstify "Screenshot Taken" --icon=dialog-information
    ;;
    colorpicker)
      ~/.local/bin/color-pick
    ;;
    *)
      #if pidof ffmpeg 
      #then
      #  killall ffmpeg
      #  dunstify 'Stopped Recording!' --icon=dialog-information
      #else
      #fi
      killall ffmpeg
      dunstify -t 5000 "Task Stopped ffmpeg" --icon=dialog-information
    ;;
esac
