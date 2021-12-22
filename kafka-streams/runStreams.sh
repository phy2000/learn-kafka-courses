#!/bin/bash
USAGE="$0 [ aggregate | basic | errors | joins | ktable | processor | time | windows ]"
TIMEOUT=60

# Default to basic
STREAM=basic

if [ $# -ge 1 ]; then
  STREAM=$1
  case $STREAM in
    "aggregate" | "basic" | "errors" | "joins" | \
    "ktable" | "processor" | "time" | "windows")
      ;;
    *)
      echo USAGE: $USAGE >&2
      exit -1
      ;;
  esac

fi
OUTDIR=./OUT
ERR=${OUTDIR}/${STREAM}.err
OUT=${OUTDIR}/${STREAM}.out
echo running $STREAM and directing output to $ERR and $OUT
echo Wait $TIMEOUT for task to end
#timeout $TIMEOUT ./gradlew runStreams -Pargs=${STREAM} > ${OUT} 2> ${ERR}
./gradlew runStreams -Pargs=${STREAM} > ${OUT} 2> ${ERR} & PID=$!

SECS=$TIMEOUT
while [ $SECS -gt 0 ]; do
   echo -ne "\t$SECS\033[0K\r"
   sleep 1
   : $((SECS--))
done
echo -e "\t0"
kill $PID
