#!/bin/sh

cd thirdparty/esl          ; tbuild clean install ; cd ../..
cd thirdparty/tinyxml2     ; tbuild clean install ; cd ../..
cd thirdparty/common4esl   ; tbuild clean install ; cd ../..
cd thirdparty/opengtx4esl  ; tbuild clean install ; cd ../..
cd thirdparty/curl4esl     ; tbuild clean install ; cd ../..
cd thirdparty/logbook      ; tbuild clean install ; cd ../..
cd thirdparty/logbook4esl  ; tbuild clean install ; cd ../..
cd thirdparty/mhd4esl      ; tbuild clean install ; cd ../..
cd thirdparty/sqlite4esl   ; tbuild clean install ; cd ../..
cd thirdparty/odbc4esl     ; tbuild clean install ; cd ../..
cd thirdparty/zsystem      ; tbuild clean install ; cd ../..
cd thirdparty/zsystem4esl  ; tbuild clean install ; cd ../..
cd openesl                 ; tbuild clean install ; cd ..
