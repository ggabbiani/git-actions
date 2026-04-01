#!/bin/bash

#
# Entry point for the OpenSCAD image builder.
#
# This file is part of the 'Git Actions' (GA) project.
#
# Copyright © 2026, Giampiero Gabbiani <giampiero@gabbiani.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

set -e # exit immediately in case of error
ROOT="$(realpath $(dirname $0)/..)"
APP=$ROOT/app
. $APP/functions.sh
trap 'on_exit $? $test' EXIT

help() {
cat <<EoH

$(basename $0) [-?|-h|--help] [-c|--camera <position>] [-p|--projection <projection>] [-r|--resolution <resolution>] [-s|--script <script name>] PICTURE

  -?|-h|--help      this help
  -c|--camera       OpenSCAD camera position
  -p|--projection   'ortho' or 'perspective'
  -r|--resolution   target resolution in 'openscad' format i.e. 800x600
  -s|--script       OpenSCAD script

EoH
exit 0
}

grep_no_rc() {
  grep $@ || true
}

on_exit() {
  if [ "$1" != "0" ]; then
    color_message ${COLOR_RED} "$2 failed."
  fi
}

VERBOSE="1"
MODE="foundation"
DRY="OFF"

##############################################################################
# parsing
POSITIONALS=""
while (( "$#" )); do
  case "$1" in
    '-?'|-h|--help)
      help
      shift
      ;;
    -c|--camera)
      CAMERA="--camera=$2"
      shift 2
      ;;
    -p|--projection)
      PROJECTION="--projection=$2"
      shift 2
      ;;
    -r|--resolution)
      RESIZE="-resize $2"
      RESOLUTION="--resolution=$2"
      shift 2
      ;;
    -s|--script)
      SCRIPT="--ofl-script=$2"
      shift 2
      ;;
    --) # end argument parsing
      shift
      EXTRAS="$@"
      break
      ;;
    -*|--*=) # unsupported flags
      fail 1 "Unsupported flag $1"
      ;;
    *) # preserve positional arguments
      POSITIONALS="$POSITIONALS $1"
      shift
      ;;
  esac
done
# set positional arguments in their proper place
eval set -- "$POSITIONALS"

if (( $# < 1 )); then
  fail 2 "Picture name expected"
fi
if [ -z "$RESOLUTION" ]; then
  fail 3 "RESOLUTION expected."
fi
if [ -z "$SCRIPT" ]; then
  fail 4 "SCRIPT expected."
fi

PIC_PATH=$1
PIC_DIR=$(dirname "$PIC_PATH")
PIC_FILE=$(basename "$PIC_PATH")
shift 1

xvfb-run -d $APP/make-picture.py $RESOLUTION $CAMERA $PROJECTION "$SCRIPT" "$PIC_PATH"
magick "$PIC_DIR/unscaled-$PIC_FILE" $RESIZE "$PIC_PATH"
rm "$PIC_DIR/unscaled-$PIC_FILE"
exit 0
