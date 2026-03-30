#!/bin/bash
###############################################################################
#
#
#
#
set -e # exit immediately in case of error
ROOT="$(realpath $(dirname $0)/..)"
BIN=$ROOT/bin
. $ROOT/bin/functions.sh
trap 'on_exit $? $test' EXIT

help() {
cat <<EoH

$(basename $0) [-?|-h|--help] [-d|--dry-run] [-s|--silent] [-c|--camera <position>] [-p|--projection <projection>] [-r|--resolution <resolution>] [-s|--script <script name>] COMMAND PICTURE

  -?|-h|--help      this help
  -n|--native       Execute OpenSCAD script without any scaling nor check
  -c|--camera       OpenSCAD camera position
  -p|--projection   'ortho' or 'perspective'
  -r|--resolution   target resolution in 'openscad' format i.e. 800x600
  -s|--script       OpenSCAD script

  COMMAND
    'native'
    'scaled'

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

if (( $# < 2 )); then
  fail 2 "Missing COMMAND aand/or PICTURE."
fi
if [ -z "$RESOLUTION" ]; then
    fail 3 "RESOLUTION expected."
fi
if [ -z "$SCRIPT" ]; then
    fail 4 "SCRIPT expected."
fi

COMMAND=$1
PICTURE=$2
shift 2

case "$COMMAND" in
  'native')
    # NOTA: crea unscaled-$PICTURE
  	$BIN/make-picture.py $RESOLUTION $CAMERA $PROJECTION $SCRIPT $PICTURE
    magick convert unscaled-$PICTURE $RESIZE $PICTURE &>/dev/null
    rm unscaled-$PICTURE
    ;;
  'scaled')
    ;;
  *)
    fail 3 "Unsupported command '$COMMAND'"
    ;;
esac

exit 0
