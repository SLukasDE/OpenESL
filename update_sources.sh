#!/bin/sh

rm -rf tinyxml2 ;     cp -a ../tinyxml2/ . ;     cd tinyxml2 ;     rm -rf src/test .cproject .project .settings .git .gitignore build .tbuild ; cd ..
rm -rf esa ;          cp -a ../esa/ . ;          cd esa ;          rm -rf src/test .cproject .project .settings .git .gitignore build .tbuild ; cd ..
rm -rf esl ;          cp -a ../esl/ . ;          cd esl ;          rm -rf src/test .cproject .project .settings .git .gitignore build .tbuild ; cd ..
rm -rf common4esl ;   cp -a ../common4esl/ . ;   cd common4esl ;   rm -rf src/test .cproject .project .settings .git .gitignore build .tbuild ; cd ..
rm -rf curl4esl ;     cp -a ../curl4esl/ . ;     cd curl4esl ;     rm -rf src/test .cproject .project .settings .git .gitignore build .tbuild ; cd ..
rm -rf logbook ;      cp -a ../logbook/ . ;      cd logbook ;      rm -rf src/test .cproject .project .settings .git .gitignore build .tbuild ; cd ..
rm -rf logbook4esl ;  cp -a ../logbook4esl/ . ;  cd logbook4esl ;  rm -rf src/test .cproject .project .settings .git .gitignore build .tbuild ; cd ..
rm -rf mhd4esl ;      cp -a ../mhd4esl/ . ;      cd mhd4esl ;      rm -rf src/test .cproject .project .settings .git .gitignore build .tbuild ; cd ..
rm -rf rdkafka4esl ;  cp -a ../rdkafka4esl/ . ;  cd rdkafka4esl ;  rm -rf src/test .cproject .project .settings .git .gitignore build .tbuild ; cd ..
rm -rf sqlite4esl ;   cp -a ../sqlite4esl/ . ;   cd sqlite4esl ;   rm -rf src/test .cproject .project .settings .git .gitignore build .tbuild ; cd ..
rm -rf unixODBC4esl ; cp -a ../unixODBC4esl/ . ; cd unixODBC4esl ; rm -rf src/test .cproject .project .settings .git .gitignore build .tbuild ; cd ..
rm -rf zsystem ;      cp -a ../zsystem/ . ;      cd zsystem ;      rm -rf src/test .cproject .project .settings .git .gitignore build .tbuild ; cd ..
rm -rf zsystem4esl ;  cp -a ../zsystem4esl/ . ;  cd zsystem4esl ;  rm -rf src/test .cproject .project .settings .git .gitignore build .tbuild ; cd ..


rm -rf include ; mkdir include
cp -a esa/src/main/esa          include
cp -a esl/src/main/esl          include
cp -a common4esl/src/main/esl   include
cp -a curl4esl/src/main/esl     include
cp -a logbook4esl/src/main/esl  include
cp -a mhd4esl/src/main/esl      include
cp -a rdkafka4esl/src/main/esl  include
cp -a sqlite4esl/src/main/esl   include
cp -a unixODBC4esl/src/main/esl include
cp -a zsystem4esl/src/main/esl  include
cp -a esl-open/src/main/esl     include
find ./include -name '*.cpp' -delete
