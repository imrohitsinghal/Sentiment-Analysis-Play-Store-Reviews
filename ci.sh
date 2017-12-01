#!/usr/bin/env bash
set -e

#Ensure all required gems are installed
bundle install


CURRENT_DIR=`pwd`

#[ -z "$JAVA_HOME" ] && echo "JAVA_HOME is NOT SET AS AN ENVIRONMENT VARIABLE. Set it first then rerun the script" && exit 1;

sleep 2

cd $CURRENT_DIR
echo "CURRENT_DIR - " $CURRENT_DIR

date=`expr $(date -v -1d +"%d")`
echo "*** FETCHING FOR PREVIOUS DAY ***"
rake PACKAGE_NAME=com.vuclip.viu REVIEW_DATE=$date  reviews:run:all
sleep 2

echo "*** ANALYSING THE FEEDBACKS ***"
rake PACKAGE_NAME=com.vuclip.viu  reviews:run:output
sleep 2


echo "*** ARTIFACTS GENERATED ***"


