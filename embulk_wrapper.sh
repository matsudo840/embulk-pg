#!/bin/sh

echo "Debugging embulk_wrapper.sh:"
echo "EMBULK_HOME: $EMBULK_HOME"
echo "GEM_HOME: $GEM_HOME"
echo "GEM_PATH: $GEM_PATH"

export JRUBY_HOME=/opt/jruby
echo "JRUBY_HOME (after export): $JRUBY_HOME"

JAVA_CMD="java -Dfile.encoding=UTF-8 -cp /opt/jruby/jruby-complete-9.4.5.0.jar:/usr/local/bin/embulk.jar org.embulk.cli.Main"

echo "Executing: $JAVA_CMD $@"
exec $JAVA_CMD "$@"