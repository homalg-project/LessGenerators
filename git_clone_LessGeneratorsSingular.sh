#!/bin/sh

## this script must be executed in LessGeneratorsSingular subdirectory

if [ -d ./LessGeneratorsSingular ]; then
    cd ./LessGeneratorsSingular
    git pull --ff-only
else
    git clone git://github.com/wagh/LessGeneratorsSingular.git
fi
