#!/bin/bash

export MPV_COMMON_OPTIONS=""

mpv_play_help() {
    cat <<EOS
mpv_play - play music or video

Usage:

mpv_play [music] [MPV_OPTIONS...]
  Play music files or uris from stdin.

mpv_play video [MPV_OPTIONS...]
  Play video files or uris from stdin.
EOS
}

mpv_play() {
    case "$1" in
        "")
            mpv_music "$@"
            ;;
        "music")
            shift
            mpv_music "$@"
            ;;
        "video")
            shift
            mpv_video "$@"
            ;;
        *)
            mpv_play_help
            return 1
           ;;
    esac
}

mpv_music() {
    local -r tmplist="$(mktemp)"
    cat - > "$tmplist"
    mpv ${MPV_COMMON_OPTIONS} --no-video --ytdl-format='worstvideo+bestaudio' --playlist="$tmplist" "$@"
}

mpv_video() {
    local -r tmplist="$(mktemp)"
    cat - > "$tmplist"
    mpv ${MPV_COMMON_OPTIONS} --ontop --border=no --autofit=600 --geometry=100%:100% --ytdl-format='[height<=480]+bestaudio' --playlist="$tmplist" "$@"
}
