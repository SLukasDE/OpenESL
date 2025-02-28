#!/bin/sh

rm -rf src ; mkdir -p src/main
rm -rf include ; mkdir -p include/src/main

cp -a thirdparty/common4esl/src/main/*   src/main/
cp -a thirdparty/curl4esl/src/main/*     src/main/
cp -a thirdparty/esl/src/main/*          src/main/
cp -a thirdparty/logbook/src/main/*      src/main/
cp -a thirdparty/logbook4esl/src/main/*  src/main/
cp -a thirdparty/mhd4esl/src/main/*      src/main/
cp -a thirdparty/odbc4esl/src/main/*     src/main/
cp -a thirdparty/opengtx4esl/src/main/*  src/main/
cp -a thirdparty/sqlite4esl/src/main/*   src/main/
cp -a thirdparty/tinyxml2/src/main/*     src/main/
cp -a thirdparty/zsystem/src/main/*      src/main/
cp -a thirdparty/zsystem4esl/src/main/*  src/main/
cp -a openesl/src/main/*                 src/main/

# create include files
# --------------------
cp -a src/main/esl include/src/main
find ./include/src/main -name '*.cpp' -delete
cp build-full.cfg include/tbuild.cfg
#cd include ; tbuild generate cdt-project architecture=linux ; cd ..
rm -rf include/.tbuild
rm -rf include/build
rm -f include/tbuild.cfg

# build openesl
# -------------
rm -f src/main/main.cpp
tbuild build-file=build-full.cfg clean install

rpmbuild --define "_topdir `pwd`/rpm" --target x86_64 -bb rpmbuild-libopenesl-1.6.0.spec
#rpmbuild --define "_topdir /workspace/rpm" --target x86_64 -bb rpmbuild-libopenesl-1.6.0.spec
mv rpm/RPMS/x86_64/*.rpm .
rm -rf rpm

rpmbuild --define "_topdir `pwd`/rpm" --target x86_64 -bb rpmbuild-libopenesl-devel-1.6.0.spec
#rpmbuild --define "_topdir /workspace/rpm" --target x86_64 -bb rpmbuild-libopenesl-devel-1.6.0.spec
mv rpm/RPMS/x86_64/*.rpm .
rm -rf rpm

rm -rf src
rm -rf build
rm -rf include
