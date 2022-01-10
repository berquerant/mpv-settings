#!/bin/bash

d=$(cd $(dirname $0); pwd)

printf "MUSIC_ROOT > "
read MUSIC_ROOT
if [ -z "$MUSIC_ROOT" ]
then
    echo "Please specify MUSIC_ROOT"
    exit 1
fi
printf "YTDL_ROOT (default: $HOME/ytdl) > "
read YTDL_ROOT
if [ -z "$YTDL_ROOT" ]
then
    YTDL_ROOT=${HOME}/ytdl
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

MPV_ZSH="${d}/mpv.zsh"
rm -f "$MPV_ZSH"
echo "#!/bin/zsh" >> "$MPV_ZSH"
echo "export MUSIC_ROOT=\"${MUSIC_ROOT}\"" >> "$MPV_ZSH"
echo "export YTDL_ROOT=\"${YTDL_ROOT}\"" >> "$MPV_ZSH"
echo "export YTDL_OUTPUTD=\"${YTDL_ROOT}/download/output\"" >> "$MPV_ZSH"
echo "export YTDL_OUTPUT_TEMPLATE=\"${YTDL_OUTPUTD}/%(title)s-%(id)s.%(ext)s\"" >> "$MPV_ZSH"
echo "export YTDL_CACHED=\"${YTDL_ROOT}/cache\"" >> "$MPV_ZSH"
echo "export YTDL_LOGD=\"${YTDL_ROOT}/log\"" >> "$MPV_ZSH"
echo "export MPV_SCREENSHOTD=\"${YTDL_ROOT}/download/screenshot\"" >> "$MPV_ZSH"
echo "export MPV_PLAYLISTD=\"${YTDL_ROOT}/playlist\"" >> "$MPV_ZSH"
echo "export MPV_WATCH_LATERD=\"${YTDL_ROOT}/watch_later\"" >> "$MPV_ZSH"
echo "export MPV_LOG=\"${YTDL_LOGD}/mpv.log\"" >> "$MPV_ZSH"
cat "${d}/mpv.zsh.tpl" >> "$MPV_ZSH"

echo "Please load ${MPV_ZSH} to use utilities"