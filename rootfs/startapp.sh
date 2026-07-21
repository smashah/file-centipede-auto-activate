#!/bin/sh

set -eu

export XCOMPOSEFILE=/config/.XCompose

# Prevent the message about an unsupported Qt theme.
unset QT_STYLE_OVERRIDE

if is-bool-val-true "${AUTO_ACTIVATE:-1}"; then
    /usr/local/bin/file-centipede-auto-activate &
fi

exec /opt/filecentipede/fileu

# vim:ft=sh:ts=4:sw=4:et:sts=4
