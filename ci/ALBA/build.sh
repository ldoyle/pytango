#!/bin/bash

echo "## In ALBA/build.sh ##"


if [ ! -z "$NODE_NAME" -a -f "$NODE_NAME" ]
then
	source "$NODE_NAME"
else
	echo "The settings file for the node $NODE_NAME does not exist!"
	exit 1
fi


export TANGO_ROOT=/tmp/jenkins/jobs/TangoLib


export LD_LIBRARY_PATH=/tmp/jenkins/jobs/TangoLib/lib:$LD_LIBRARY_PATH
export CPLUS_INCLUDE_PATH=/tmp/jenkins/jobs/TangoLib/include:$CPLUS_INCLUDE_PATH


echo $LD_LIBRARY_PATH
echo $CPLUS_INCLUDE_PATH


cd ../..

pwd

make user=1 prefix=/tmp/jenkins/jobs install

make user=1 prefix=/tmp/jenkins/jobs install

export PYTHONPATH=/tmp/jenkins/jobs/PyTango:$PYTHONPATH

echo $PYTHONPATH

python tests/DevTest.py pytomasz &

python tests/TestSuite.py

ps -ef | awk '/DevTest.py/ {print$2}' | xargs kill -9
