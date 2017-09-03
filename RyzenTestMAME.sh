#!/bin/bash
export LANG=C
 
COMPILE_JOBS=0
LOOP_COUNTER=0
START_DATE=0
BUILD_DATE=0
SUCCESS_DATE=0
FAIL_DATE=0
LOG_DATE=0
LOG_PATH="$(pwd)/ryzen_test.log"

function logsystem {
    LOG_DATE=`/bin/date`
    
    echo -e "$1 'free -m' dump at $LOG_DATE:" >> $LOG_PATH
    free -m >> $LOG_PATH
    echo "" >> $LOG_PATH
    
    echo -e "$1 'sensors' dump at $LOG_DATE:" >> $LOG_PATH
    sensors >> $LOG_PATH || :
    echo "" >> $LOG_PATH
}

if [ -z "$1" ]; then
    COMPILE_JOBS=`/bin/nproc`    
else
    COMPILE_JOBS=$1
fi

logsystem "Initial setup"

if [ ! -d temp ] ; then
    mkdir temp || exit 1
fi

if [ ! -f mame0189s.zip ] ; then
    echo "Download and extract MAME"
    wget https://github.com/mamedev/mame/releases/download/mame0189/mame0189s.zip || exit 1    
fi

if [ ! -f ./temp/mame.zip ] ; then
    unzip -qq mame0189s.zip -d temp || :
fi
    
cd temp || exit 1

START_DATE=`/bin/date`

while true ; do
    if [ -d mame ] ; then
        rm -rf mame || exit 1
    fi    
    unzip -qq mame.zip -d mame || :
    BUILD_DATE=`/bin/date`    
    
    echo "Build $LOOP_COUNTER started at $BUILD_DATE" >> $LOG_PATH
    echo "Build $LOOP_COUNTER started at: $BUILD_DATE"
    cd mame || exit 1
    make -j $COMPILE_JOBS &> mame_build_output.log || break   
    
    SUCCESS_DATE=`/bin/date`    
    echo "Build $LOOP_COUNTER succcessful at $SUCCESS_DATE" >> $LOG_PATH
    logsystem "Completed build $LOOP_COUNTER"
    echo "Build $LOOP_COUNTER completed at: $SUCCESS_DATE"
    LOOP_COUNTER=$((LOOP_COUNTER+1))
    cd ../ || exit 1
done

FAIL_DATE=`/bin/date`
logsystem "Failed build"

echo "      -------- Test unsuccessful! --------" >> $LOG_PATH
echo "Test start date and time: $START_DATE" >> $LOG_PATH
echo "Compile jobs (make -j xx): $COMPILE_JOBS" >> $LOG_PATH
echo "Successful builds: $LOOP_COUNTER" >> $LOG_PATH
echo "Failed build date and time: $FAIL_DATE" >> $LOG_PATH
echo "Build loop failed at: $FAIL_DATE"
