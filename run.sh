#!/bin/bash

JBOSS_VERSION="jboss-as-7.1.1.Final"
HOME="/opt/jboss"
JBOSS_HOME="$HOME/$JBOSS_VERSION"

cd $JBOSS_HOME/bin

su -c "$JBOSS_HOME/bin/standalone.sh &> /dev/null" jboss
