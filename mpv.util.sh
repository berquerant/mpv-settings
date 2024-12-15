#!/bin/bash

export MPV_COMMON_OPTIONS=""

export MPV_PLAY_HISTORY="${YTDL_LOGD}/mpv.play.history"
# mpv-append-play-history [UUID] LOG
# append following log to MPV_PLAY_HISTORY:
#   DATETIME UUID LOG
# DATETIME format is %Y-%m-%d %H:%M:%S
# generate UUID if UUID is omitted
mpv-append-play-history() {
    local uid
    if [ $# = 1 ] ; then
        uid="$(uuidgen)"
    else
        uid="$1"
        shift
    fi
    local now
    now="$(date "+%Y-%m-%d %H:%M:%S")"
    echo "${now} ${uid} $*" >> "$MPV_PLAY_HISTORY"
}

mpv-play-help() {
    cat <<EOS
mpv-play - play music or video

Usage:

mpv-play [music] [playlist]
  Play music files or uris from stdin or playlist.

mpv-play video [playlist]
  Play video files or uris from stdin or playlist.
EOS
}

mpv-play() {
    if [ $# = 0 ] ; then
        mpv-play-help
        return 1
    fi
    case "$1" in
        "")
            mpv-music "$@"
            ;;
        "music")
            shift
            mpv-music "$@"
            ;;
        "video")
            shift
            mpv-video "$@"
            ;;
        *)
            mpv-play-help
            return 1
           ;;
    esac
}

mpv-music() {
    if [ $# -gt 0 ] ; then
        mpv ${MPV_COMMON_OPTIONS} --no-video --ytdl-format='worstvideo+bestaudio' --shuffle --playlist="$1"
        return 0
    fi
    local uid
    uid="$(uuidgen)"
    while read -r line ; do
        echo "$line"
        mpv-append-play-history "$uid" "music $line"
        mpv ${MPV_COMMON_OPTIONS} --no-video --ytdl-format='worstvideo+bestaudio' "$line"
    done
}

mpv-video() {
    if [ $# -gt 0 ] ; then
        mpv ${MPV_COMMON_OPTIONS} --ontop --border=no --autofit=600 --geometry=100%:100% --ytdl-format='[height<=480]+bestaudio' --shuffle --playlist="$1"
        return 0
    fi
    local uid
    uid="$(uuidgen)"
    while read -r line ; do
        echo "$line"
        mpv-append-play-history "$uid" "video $line"
        mpv ${MPV_COMMON_OPTIONS} --ontop --border=no --autofit=600 --geometry=100%:100% --ytdl-format='[height<=480]+bestaudio' "$line"
    done
}
