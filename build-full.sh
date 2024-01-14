#!/bin/sh

rm -rf src ; mkdir -p src/main
rm -rf include ; mkdir -p include/src/main

cp -a common4esl/src/main/*   src/main/
cp -a curl4esl/src/main/*     src/main/
cp -a esa/src/main/*          src/main/
cp -a esl/src/main/*          src/main/
cp -a logbook/src/main/*      src/main/
cp -a logbook4esl/src/main/*  src/main/
cp -a mhd4esl/src/main/*      src/main/
cp -a open-gtx4esl/src/main/* src/main/
cp -a sqlite4esl/src/main/*   src/main/
cp -a tinyxml2/src/main/*     src/main/
cp -a unixODBC4esl/src/main/* src/main/
cp -a zsystem/src/main/*      src/main/
cp -a zsystem4esl/src/main/*  src/main/
cp -a openesl/src/main/*       src/main/

# create include files
# --------------------
cp -a src/main/esa include/src/main
cp -a src/main/esl include/src/main
find ./include/src/main -name '*.cpp' -delete
cp build-full.cfg include/tbuild.cfg
cd include ; tbuild2 generate cdt-project architecture=linux ; cd ..
rm -rf include/.tbuild
rm -rf include/build
rm -f include/tbuild.cfg

# build openesl
# -------------
rm -f src/main/main.cpp
tbuild2 build-file=build-full.cfg clean install

#rpmbuild --define "_topdir `pwd`/rpm" --target x86_64 -bb rpmbuild-libopenesl-1.6.0.spec
toolcontainer rpmbuild --define "_topdir /workspace/rpm" --target x86_64 -bb rpmbuild-libopenesl-1.6.0.spec
mv rpm/RPMS/x86_64/*.rpm .
rm -rf rpm

#rpmbuild --define "_topdir `pwd`/rpm" --target x86_64 -bb rpmbuild-libopenesl-devel-1.6.0.spec
toolcontainer rpmbuild --define "_topdir /workspace/rpm" --target x86_64 -bb rpmbuild-libopenesl-devel-1.6.0.spec
mv rpm/RPMS/x86_64/*.rpm .
rm -rf rpm

rm -rf src
rm -rf build
