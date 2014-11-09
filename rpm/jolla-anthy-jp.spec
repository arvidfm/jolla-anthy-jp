Name: jolla-anthy-jp
Version: 0.03
Release: 1%{?dist}
Summary: Japanese layout and input method for Sailfish OS
License: LGPLv2
Source: %{name}-%{version}.tar.gz
URL: https://github.com/BeholdMyGlory/jolla-anthy-jp
Requires:   libanthy-qml-plugin
Requires:   jolla-keyboard
Requires:   jolla-xt9

%description
Allows you to type in Japanese on Sailfish OS.

%define debug_package %{nil}

%prep
%setup -q

%build
# do nothing

%install
#rm -rf %{buildroot}
#make install DESTDIR=%{buildroot}
mkdir -p %{buildroot}/usr/share/maliit/plugins/com/jolla/layouts/
cp -r src/ja_romaji* %{buildroot}/usr/share/maliit/plugins/com/jolla/layouts/

%clean
rm -rf %{buildroot}

%files
/usr/share/maliit/plugins/com/jolla/layouts/ja_romaji.qml
/usr/share/maliit/plugins/com/jolla/layouts/ja_romaji.conf
/usr/share/maliit/plugins/com/jolla/layouts/ja_romaji/JaInputHandler.qml
/usr/share/maliit/plugins/com/jolla/layouts/ja_romaji/parse_romaji.js
