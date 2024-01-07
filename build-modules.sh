#!/bin/sh

cd esa          ; tbuild2 clean install ; cd ..
cd esl          ; tbuild2 clean install ; cd ..
cd tinyxml2     ; tbuild2 clean install ; cd ..
cd common4esl   ; tbuild2 clean install ; cd ..
cd open-gtx4esl ; tbuild2 clean install ; cd ..
cd curl4esl     ; tbuild2 clean install ; cd ..
cd logbook      ; tbuild2 clean install ; cd ..
cd logbook4esl  ; tbuild2 clean install ; cd ..
cd mhd4esl      ; tbuild2 clean install ; cd ..
cd rdkafka4esl  ; tbuild2 clean install ; cd ..
cd sqlite4esl   ; tbuild2 clean install ; cd ..
cd unixODBC4esl ; tbuild2 clean install ; cd ..
cd zsystem      ; tbuild2 clean install ; cd ..
cd zsystem4esl  ; tbuild2 clean install ; cd ..
cd open-esl     ; tbuild2 clean install ; cd ..
