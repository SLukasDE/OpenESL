#!/bin/sh

rm -rf include

cd ../esl-pro/ ; ./update-includes.sh ; cd ../open-esl
cp -a ../esl-pro/include include
