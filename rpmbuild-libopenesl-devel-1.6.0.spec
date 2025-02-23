##########################################
# Spec file for Open ESL development files
##########################################

Summary: Open ESL development files
Name: libopenesl-devel
Version: 1.6.0
Release: 1
License: Freeware
URL: http://www.sven-lukas.de
Group: System
Packager: Sven Lukas
Requires: libopenesl = 1.6.0
Requires: libopenesl-devel = 1.6.0
BuildRoot: ./rpmbuild/

%description
Open ESL development files.

%prep
#echo "BUILDROOT = $RPM_BUILD_ROOT"
#echo "Current path: $PWD"

mkdir -p $RPM_BUILD_ROOT/usr/include/esl-1.6.0

cp -a ../../include/src/main/esl/*    $RPM_BUILD_ROOT/usr/include/esl-1.6.0

cd ../../rpm/BUILD
ln -s esl-1.6.0    $RPM_BUILD_ROOT/usr/include/esl

exit

%files
%defattr(644, root, root, 755)
/usr/include/esl-1.6.0
/usr/include/esl

%pre

%post

%postun

%clean
rm -rf $RPM_BUILD_ROOT/usr/include/esl

%changelog
* Sun Jan 14 2024 Sven Lukas <sven.lukas@gmail.com>
  - New version for esl 1.6.0
* Sun Jul 24 2022 Sven Lukas <sven.lukas@gmail.com>
  - New version for esl 1.5.0
* Sun Jan 16 2022 Sven Lukas <sven.lukas@gmail.com>
  - First prebuild RPM
