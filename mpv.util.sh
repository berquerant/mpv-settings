#!/bin/bash

export MPV_COMMON_OPTIONS=""

export MPV_PLAY_HISTORY="${YTDL_LOGD}/mpv.play.history"
# mpv_append_play_history [UUID] LOG
# append following log to MPV_PLAY_HISTORY:
#   DATETIME UUID LOG
# DATETIME format is %Y-%m-%d %H:%M:%S
# generate UUID if UUID is omitted
mpv_append_play_history() {
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

mpv_play_help() {
    cat <<EOS
mpv_play - play music or video

Usage:

mpv_play [music] [playlist]
  Play music files or uris from stdin or playlist.

mpv_play video [playlist]
  Play video files or uris from stdin or playlist.
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
    if [ $# -gt 0 ] ; then
        mpv ${MPV_COMMON_OPTIONS} --no-video --ytdl-format='worstvideo+bestaudio' --shuffle --playlist="$1"
        return 0
    fi
    local finished
    local pid
    __cleanup() {
        finished=1
        if [ -n "$pid" ] ; then
            kill "$pid"
        fi
    }
    trap __cleanup SIGINT
    local uid
    uid="$(uuidgen)"
    while read -r line ; do
        if ((finished)) ; then
            return 1
        fi
        echo "$line"
        mpv_append_play_history "$uid" "music $line"
        mpv ${MPV_COMMON_OPTIONS} --no-video --ytdl-format='worstvideo+bestaudio' "$line" &
        pid=$!
        wait "$pid"
        pid=""
    done
}

mpv_video() {
    if [ $# -gt 0 ] ; then
        mpv ${MPV_COMMON_OPTIONS} --ontop --border=no --autofit=600 --geometry=100%:100% --ytdl-format='[height<=480]+bestaudio' --shuffle --playlist="$1"
        return 0
    fi
    local finished
    local pid
    __cleanup() {
        finished=1
        if [ -n "$pid" ] ; then
            kill "$pid"
        fi
    }
    trap __cleanup SIGINT
    local uid
    uid="$(uuidgen)"
    while read -r line ; do
        if ((finished)) ; then
            return 1
        fi
        echo "$line"
        mpv_append_play_history "$uid" "video $line"
        mpv ${MPV_COMMON_OPTIONS} --ontop --border=no --autofit=600 --geometry=100%:100% --ytdl-format='[height<=480]+bestaudio' "$line" &
        pid=$!
        wait "$pid"
        pid=""
    done
}
