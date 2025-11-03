################################
# Spec file for Open ESL library
################################

Summary: Open ESL library
Name: libopenesl
Version: 1.6.0
Release: 1
License: Freeware
URL: http://www.sven-lukas.de
Group: System
Packager: Sven Lukas
Requires: /bin/addr2line
BuildRoot: ./rpmbuild/

%description
C++ library to support easy and fast development of state of the art enterprise informaiton systems.

%prep
#echo "BUILDROOT = $RPM_BUILD_ROOT"
#mkdir -p $RPM_BUILD_ROOT/etc
#cp -a ../../eslx-config.xml $RPM_BUILD_ROOT/etc

mkdir -p $RPM_BUILD_ROOT/usr/lib64
cp -a ../../build/open-esl/1.6.0/default/architecture/linux-gcc/link-static/libopenesl.a $RPM_BUILD_ROOT/usr/lib64
cp -a ../../build/open-esl/1.6.0/default/architecture/linux-gcc/link-dynamic/libopenesl.so $RPM_BUILD_ROOT/usr/lib64/libopenesl.so.1.6.0
ln -s libopenesl.so.1.6.0 $RPM_BUILD_ROOT/usr/lib64/libopenesl.so.1.6
ln -s libopenesl.so.1.6.0 $RPM_BUILD_ROOT/usr/lib64/libopenesl.so

#cp -a ../../old/libeslx.so.1.4.1 $RPM_BUILD_ROOT/usr/lib64/libeslx.so.1.5.1
#ln -s libeslx.so.1.5.1 $RPM_BUILD_ROOT/usr/lib64/libeslx.so.1.5

#cp -a ../../old/libeslx.so.1.4.1 $RPM_BUILD_ROOT/usr/lib64/libeslx.so.1.4.1
#ln -s libeslx.so.1.4.1 $RPM_BUILD_ROOT/usr/lib64/libeslx.so.1.4
#cp -a ../../old/libcurl4esl_fix1.so $RPM_BUILD_ROOT/usr/lib64/libcurl4esl_fix1.so

exit

%files
%attr(0755, root, root) /usr/lib64/libopenesl.so.1.6.0
%attr(0777, root, root) /usr/lib64/libopenesl.so.1.6
%attr(0777, root, root) /usr/lib64/libopenesl.so
%attr(0644, root, root) /usr/lib64/libopenesl.a
#%attr(0755, root, root) /usr/lib64/libeslx.so.1.5.1
#%attr(0777, root, root) /usr/lib64/libeslx.so.1.5
#%attr(0755, root, root) /usr/lib64/libeslx.so.1.4.1
#%attr(0777, root, root) /usr/lib64/libeslx.so.1.4
#%attr(0755, root, root) /usr/lib64/libcurl4esl_fix1.so

%pre

%post

%postun

%clean

%changelog
* Sun Jan 14 2024 Sven Lukas <sven.lukas@gmail.com>
  - New version for esl 1.6.0
* Sun Jul 24 2022 Sven Lukas <sven.lukas@gmail.com>
  - New version for esl 1.5.0
* Sun Jan 16 2022 Sven Lukas <sven.lukas@gmail.com>
  - First prebuild RPM
