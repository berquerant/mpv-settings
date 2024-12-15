#!/bin/bash

d="$(cd "$(dirname "$0")" || exit; pwd)"

if [ -z "$MUSIC_ROOT" ]
then
    echo -n "MUSIC_ROOT > "
    read MUSIC_ROOT
fi
if [ -z "$MUSIC_ROOT" ]
then
    echo "Please specify MUSIC_ROOT"
    exit 1
fi

if ! env | grep -q "YTDL_ROOT"
then
    echo -n "YTDL_ROOT (default: $HOME/ytdl) > "
    read YTDL_ROOT
fi
if [ -z "$YTDL_ROOT" ]
then
    YTDL_ROOT="${HOME}/ytdl"
fi

export YTDL_ROOT
export YTDL_OUTPUTD="${YTDL_ROOT}/download/output"
export YTDL_OUTPUT_TEMPLATE="${YTDL_OUTPUTD}/%(title)s-%(id)s.%(ext)s"
export YTDL_CACHED="${YTDL_ROOT}/cache"
export YTDL_LOGD="${YTDL_ROOT}/log"
export MPV_SCREENSHOTD="${YTDL_ROOT}/download/screenshot"
export MPV_PLAYLISTD="${YTDL_ROOT}/playlist"
export MPV_WATCH_LATERD="${YTDL_ROOT}/watch_later"
export MPV_LOG="${YTDL_LOGD}/mpv.log"

mkdir -p "${HOME}/.config" "$YTDL_ROOT" "$YTDL_OUTPUTD" "$YTDL_CACHED" "$YTDL_LOGD" "$MPV_SCREENSHOTD" "$MPV_PLAYLISTD" "$MPV_WATCH_LATERD"
envsubst < "${d}/mpv/mpv.conf.tpl" > "${d}/mpv/mpv.conf"
ln -snvf "${d}/mpv" "${HOME}/.config/"

MPV_SH="${d}/mpv.sh"
cat > "$MPV_SH" << EOS
#!/bin/bash
export MUSIC_ROOT="${MUSIC_ROOT}"
export YTDL_ROOT="${YTDL_ROOT}"
export YTDL_OUTPUTD="${YTDL_ROOT}/download/output"
export YTDL_OUTPUT_TEMPLATE="${YTDL_OUTPUTD}/%(title)s-%(id)s.%(ext)s"
export YTDL_CACHED="${YTDL_ROOT}/cache"
export YTDL_LOGD="${YTDL_ROOT}/log"
export MPV_SCREENSHOTD="${YTDL_ROOT}/download/screenshot"
export MPV_PLAYLISTD="${YTDL_ROOT}/playlist"
export MPV_WATCH_LATERD="${YTDL_ROOT}/watch_later"
export MPV_LOG="${YTDL_LOGD}/mpv.log"
source ${d}/mpv.util.sh
EOS
