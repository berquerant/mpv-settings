#!/bin/zsh

export MPV_COMMON_OPTIONS=""

alias mpv-find-music='find $MUSIC_ROOT -type f | peco'
alias mpv-find-playlist='find $MPV_PLAYLISTD -type f | sort -r | peco'
alias mpv-dump-playlist='cat `mpv-playlist`'

export MPV_PLAY_HISTORY="${YTDL_LOGD}/mpv.play.history"
# mpv-append-play-history [UUID] LOG
# append following log to MPV_PLAY_HISTORY:
#   DATETIME UUID LOG
# DATETIME format is %Y-%m-%d %H:%M:%S
# generate UUID if UUID is omitted
mpv-append-play-history() {
    local uid
    if [ $# = 1 ] ; then
        uid=`uuidgen`
    else
        uid="$1"
        shift
    fi
    local now=`date "+%Y-%m-%d %H:%M:%S"`
    echo "${now} ${uid} $1" >> "$MPV_PLAY_HISTORY"
}

mpv-play-help() {
    cat <<EOS
mpv-play - play music or video

Usage:

mpv-play music
  Play music files or uris from stdin.

mpv-play video
  Play video files or uris from stdin.
EOS
}

mpv-play() {
    if [ $# = 0 ] ; then
        mpv-play-help
        return 1
    fi
    case "$1" in
        "music") mpv-music
                 ;;
        "video") mpv-video
                 ;;
        *) mpv-play-help
           return 1
           ;;
    esac
}

mpv-music() {
    local uid=`uuidgen`
    while read line ; do
        echo $line
        mpv-append-play-history "$uid" "music $line"
        mpv ${MPV_COMMON_OPTIONS} --no-video --ytdl-format='worstvideo+bestaudio' "$line"
    done
}

mpv-video() {
    local uid=`uuidgen`
    while read line ; do
        echo $line
        mpv-append-play-history "$uid" "video $line"
        mpv ${MPV_COMMON_OPTIONS} --ontop --border=no --autofit=600 --geometry=100%:100% --ytdl-format='[height<=480]+bestaudio' "$line"
    done
}
