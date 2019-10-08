# Prevent brp-python-bytecompile from running.
%define __os_install_post %{___build_post}

# "Harbour RPM packages should not provide anything."
%define __provides_exclude_from ^%{_datadir}/.*$

Name: harbour-pure-maps
Version: 1.26.1
Release: 1
Summary: Maps and navigation
License: GPLv3+
URL: https://github.com/rinigus/pure-maps
Source: %{name}-%{version}.tar.xz
BuildArch: noarch
BuildRequires: gettext
BuildRequires: make
BuildRequires: qt5-qttools-linguist
Requires: libkeepalive
Requires: libsailfishapp-launcher
Requires: mapboxgl-qml >= 1.5.0.2
Requires: pyotherside-qml-plugin-python3-qt5 >= 1.5.1
Requires: qt5-qtdeclarative-import-multimedia >= 5.2
Requires: qt5-qtdeclarative-import-positioning >= 5.2
Requires: sailfishsilica-qt5

%description
View maps, find places and routes, navigate with turn-by-turn instructions,
search for nearby places by type and share your location.

%prep
%setup -q

%install
make DESTDIR=%{buildroot} PREFIX=/usr INCLUDE_GPXPY=yes install

%files
%defattr(-,root,root,-)
%{_bindir}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/applications/%{name}-uri-handler.desktop
#%{_datadir}/dbus-1/services/io.github.rinigus.PureMaps.service
%{_datadir}/icons/hicolor/*/apps/%{name}.png
%exclude /usr/share/metainfo/harbour-pure-maps.appdata.xml
