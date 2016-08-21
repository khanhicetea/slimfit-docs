#!/bin/bash

hugo -d docs
RETVAL=$?

if [ $RETVAL -ne 0 ]
then
    exit 1
fi

