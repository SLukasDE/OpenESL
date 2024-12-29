#!/bin/sh

#cd tinyxml2     ; tbuild2 clean install ; cd .. # required by common4esl
#cd logbook      ; tbuild2 clean install ; cd .. # required by logbook4esl
#cd zsystem      ; tbuild2 clean install ; cd .. # required by zsystem4esl
#cd ../gtx       ; tbuild2 clean install ; cd ../esl-pro
#cd rapidjson    ; tbuild2 clean install ; cd .. # required by logscale4esl
#cd tinyxml      ; tbuild2 clean install ; cd .. # required by sergut
#cd sergut       ; tbuild2 clean install ; cd .. # required by oidc4esl

cd thirdparty/esa          ; tbuild2 clean install ; cd ../..
cd thirdparty/esl          ; tbuild2 clean install ; cd ../..
cd thirdparty/tinyxml2     ; tbuild2 clean install ; cd ../..
cd thirdparty/common4esl   ; tbuild2 clean install ; cd ../..
cd thirdparty/opengtx4esl  ; tbuild2 clean install ; cd ../..
cd thirdparty/curl4esl     ; tbuild2 clean install ; cd ../..
cd thirdparty/logbook      ; tbuild2 clean install ; cd ../..
cd thirdparty/logbook4esl  ; tbuild2 clean install ; cd ../..
cd thirdparty/mhd4esl      ; tbuild2 clean install ; cd ../..
cd thirdparty/sqlite4esl   ; tbuild2 clean install ; cd ../..
cd thirdparty/odbc4esl     ; tbuild2 clean install ; cd ../..
cd thirdparty/zsystem      ; tbuild2 clean install ; cd ../..
cd thirdparty/zsystem4esl  ; tbuild2 clean install ; cd ../..
cd openesl                 ; tbuild2 clean install ; cd ..
