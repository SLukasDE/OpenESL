#!/bin/sh

#cd tinyxml2     ; tbuild2 clean install ; cd .. # required by common4esl
#cd logbook      ; tbuild2 clean install ; cd .. # required by logbook4esl
#cd zsystem      ; tbuild2 clean install ; cd .. # required by zsystem4esl
#cd ../gtx       ; tbuild2 clean install ; cd ../esl-pro
#cd rapidjson    ; tbuild2 clean install ; cd .. # required by logscale4esl
#cd tinyxml      ; tbuild2 clean install ; cd .. # required by sergut
#cd sergut       ; tbuild2 clean install ; cd .. # required by oidc4esl

cd esa          ; tbuild2 clean install ; cd ..
cd esl          ; tbuild2 clean install ; cd ..
cd common4esl   ; tbuild2 clean install ; cd ..
cd open-gtx4esl ; tbuild2 clean install ; cd ..
cd curl4esl     ; tbuild2 clean install ; cd ..
cd logbook4esl  ; tbuild2 clean install ; cd ..
cd mhd4esl      ; tbuild2 clean install ; cd ..
cd sqlite4esl   ; tbuild2 clean install ; cd ..
cd unixODBC4esl ; tbuild2 clean install ; cd ..
cd zsystem4esl  ; tbuild2 clean install ; cd ..
cd openesl      ; tbuild2 clean install ; cd ..
