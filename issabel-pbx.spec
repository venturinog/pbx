%define modname pbx
Summary: Issabel PBX Module
Name:    issabel-pbx
Version: 6.0.0
Release: 17
License: GPL
Group:   Applications/System
Source0: issabel-%{modname}-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-root
BuildArch: noarch
Requires(pre): issabel-framework >= 6.0.0-22
Requires(pre): issabel-my_extension >= 5.0.0-1
Requires(pre): issabel-system >= 5.0.0-1
Requires(pre): vsftpd
#Requires(pre): asterisk >= 1.8
Requires: festival >= 1.95
Requires: picotts
Requires(pre): issabelPBX >= 2.12.0

#Requires: issabel-endpointconfig2 >= 4.0.0-1

# commands: mv chown
Requires: coreutils

# commands: sed
Requires: sed

# commands: grep
Requires: grep

# commands: /usr/bin/killall
Requires: psmisc

# commands: /usr/bin/sqlite3
Requires: sqlite

# commands: /usr/sbin/chkconfig
Requires: chkconfig

Requires: /usr/sbin/pidof

Obsoletes: elastix-pbx

%description
Issabel PBX Module

%prep
%setup -n %{name}-%{version}

%install
rm -rf $RPM_BUILD_ROOT

# Asterisk files
mkdir -p $RPM_BUILD_ROOT/var/lib/asterisk/agi-bin
mkdir -p $RPM_BUILD_ROOT/var/lib/asterisk/moh

mkdir -p $RPM_BUILD_ROOT/etc/cron.daily

# ** /bin path ** #
mkdir -p $RPM_BUILD_ROOT/usr/bin

# Files provided by all Issabel modules
mkdir -p    $RPM_BUILD_ROOT/var/www/html/
mv modules/ $RPM_BUILD_ROOT/var/www/html/

# ** files ftp ** #
#mkdir -p $RPM_BUILD_ROOT/var/ftp/config

# ** /asterisk path ** #
mkdir -p $RPM_BUILD_ROOT/etc/asterisk/

# ** service festival ** #
mkdir -p $RPM_BUILD_ROOT/etc/init.d/
mkdir -p $RPM_BUILD_ROOT/var/log/festival/

# The following folder should contain all the data that is required by the installer,
# that cannot be handled by RPM.
mkdir -p      $RPM_BUILD_ROOT/usr/share/issabel/module_installer/%{name}-%{version}-%{release}/
mkdir -p      $RPM_BUILD_ROOT/usr/share/issabel/privileged/

# crons config
mv setup/etc/cron.daily/asterisk_cleanup      $RPM_BUILD_ROOT/etc/cron.daily/
chmod 755 $RPM_BUILD_ROOT/etc/cron.daily/*
rmdir setup/etc/cron.daily/

# ** asterisk.reload file ** #
mv setup/bin/asterisk.reload                  $RPM_BUILD_ROOT/usr/bin/
chmod 755 $RPM_BUILD_ROOT/usr/bin/asterisk.reload
rmdir setup/bin

# ** files asterisk for agi-bin and moh ** #
mv setup/asterisk/agi-bin/*                   $RPM_BUILD_ROOT/var/lib/asterisk/agi-bin/
chmod 755 $RPM_BUILD_ROOT/var/lib/asterisk/agi-bin/*
mv setup/asterisk/moh/*                    $RPM_BUILD_ROOT/var/lib/asterisk/moh/
rmdir setup/asterisk/*
rmdir setup/asterisk

# issabel_issabelpbx
mkdir -p $RPM_BUILD_ROOT/var/www/html/admin/
mv setup/var/www/html/admin/issabel_issabelpbx_auth.php $RPM_BUILD_ROOT/var/www/html/admin/
rmdir setup/var/www/html/admin
rmdir setup/var/www/html
rmdir setup/var/www
rmdir setup/var

# Moviendo archivos festival y sip_notify_custom_issabel.conf
chmod +x setup/etc/asterisk/sip_notify_custom_issabel.conf
chmod +x setup/etc/init.d/festival
mv setup/etc/asterisk/sip_notify_custom_issabel.conf      $RPM_BUILD_ROOT/etc/asterisk/
mv setup/etc/init.d/festival                              $RPM_BUILD_ROOT/etc/init.d/
mv setup/usr/share/issabel/privileged/*                   $RPM_BUILD_ROOT/usr/share/issabel/privileged/
mv setup/etc/httpd/                                       $RPM_BUILD_ROOT/etc/
rmdir setup/etc/init.d
rmdir setup/etc/asterisk
rmdir setup/usr/share/issabel/privileged

rmdir setup/usr/share/issabel setup/usr/share setup/usr

chmod +x setup/migrationFilesMonitor*php
mv setup/     $RPM_BUILD_ROOT/usr/share/issabel/module_installer/%{name}-%{version}-%{release}/
mv menu.xml   $RPM_BUILD_ROOT/usr/share/issabel/module_installer/%{name}-%{version}-%{release}/


%pre
#Para migrar monitor
touch /tmp/migration_version_monitor.info
rpm -q --queryformat='%%{VERSION}\n%%{RELEASE}' issabel > /tmp/migration_version_monitor.info

# TODO: TAREA DE POST-INSTALACIÓN
#useradd -d /var/ftp -M -s /usr/sbin/nologin ftpuser

# Try to fix mess left behind by previous packages.
if [ -e /etc/vsftpd.user_list ] ; then
    echo "   NOTICE: broken vsftpd detected, will try to fix..."
    cp /etc/vsftpd.user_list /tmp/
fi

mkdir -p /usr/share/issabel/module_installer/%{name}-%{version}-%{release}/
touch /usr/share/issabel/module_installer/%{name}-%{version}-%{release}/preversion_%{modname}.info
if [ $1 -eq 2 ]; then
    rpm -q --queryformat='%%{VERSION}-%%{RELEASE}' %{name} > /usr/share/issabel/module_installer/%{name}-%{version}-%{release}/preversion_%{modname}.info
fi

%post
######### Para ejecucion del migrationFilesMonitor.php ##############

#/usr/share/issabel/migration_version_monitor.info
#obtener la primera linea que contiene la version

vers=`sed -n '1p' "/tmp/migration_version_monitor.info"`
if [ "$vers" = "1.6.2" ]; then
  rels=`sed -n '2p' "/tmp/migration_version_monitor.info"`
  if [ $rels -le 13 ]; then # si el release es menor o igual a 13 entonces ejecuto el script

    echo "Executing process migration audio files Monitor"
    chmod +x /usr/share/issabel/module_installer/%{name}-%{version}-%{release}/setup/migrationFilesMonitor.php
    php /usr/share/issabel/module_installer/%{name}-%{version}-%{release}/setup/migrationFilesMonitor.php
  fi
fi
rm -rf /tmp/migration_version_monitor.info
###################################################################

varwriter=0

if [ -f "/etc/asterisk/extensions_override_issabelpbx.conf" ]; then
    echo "File extensions_override_issabelpbx.conf in asterisk exits, verifying macro record-enable and hangupcall exists..."
    grep "#include extensions_override_issabel.conf" /etc/asterisk/extensions_override_issabelpbx.conf &>/dev/null
    res=$?
    if [ $res -eq 1 ]; then #macro record-enable not exists
	echo "#include extensions_override_issabel.conf" > /tmp/ext_over_issabelpbx.conf
        cat /etc/asterisk/extensions_override_issabelpbx.conf >> /tmp/ext_over_issabelpbx.conf
        cat /tmp/ext_over_issabelpbx.conf > /etc/asterisk/extensions_override_issabelpbx.conf
	rm -rf /tmp/ext_over_issabelpbx.conf
        echo "macros issabel written."
    fi
else
    echo "File extensions_override_issabelpbx.conf in asterisk not exits, copying include macros for Issabel..."
    touch /etc/asterisk/extensions_override_issabelpbx.conf
    echo "#include extensions_override_issabel.conf" > /etc/asterisk/extensions_override_issabelpbx.conf
fi

# se verifica si extensions_override_issabel.conf usa audio: sin migrar
if [ -f "/etc/asterisk/extensions_override_issabel.conf" ]; then
    if grep -q 'audio:' /etc/asterisk/extensions_override_issabel.conf ; then
        echo "/etc/asterisk/extensions_override_issabel.conf contains CDR(userfield)=audio: , migrating database..."
        /usr/share/issabel/module_installer/%{name}-%{version}-%{release}/setup/migrationFilesMonitor2.php
    fi
fi

# verifico si se incluye a sip_notify_custom_issabel.conf
if [ -f "/etc/asterisk/sip_notify_custom.conf" ]; then
    echo "/etc/asterisk/sip_notify_custom.conf exists, verifying the inclusion of sip_notify_custom_issabel.conf"
    grep "#include sip_notify_custom_issabel.conf" /etc/asterisk/sip_notify_custom.conf &> /dev/null
    if [ $? -eq 1 ]; then
	echo "including sip_notify_custom_issabel.conf..."
	echo "#include sip_notify_custom_issabel.conf" > /tmp/custom_issabel.conf
	cat /etc/asterisk/sip_notify_custom.conf >> /tmp/custom_issabel.conf
	cat /tmp/custom_issabel.conf > /etc/asterisk/sip_notify_custom.conf
	rm -rf /tmp/custom_issabel.conf
    else
	echo "sip_notify_custom_issabel.conf is already included"
    fi
else
    echo "creating file /etc/asterisk/sip_notify_custom.conf"
    touch /etc/asterisk/sip_notify_custom.conf
    echo "#include sip_notify_custom_issabel.conf" > /etc/asterisk/sip_notify_custom.conf
fi

varwriter=1
cp /usr/share/issabel/module_installer/%{name}-%{version}-%{release}/setup/extensions_override_issabel.conf /etc/asterisk/
chown -R asterisk.asterisk /etc/asterisk

if [ $varwriter -eq 1  ]; then
    service asterisk status &>/dev/null
    res2=$?
    if [ $res2 -eq 0  ]; then #service is up
         service asterisk reload
    fi
fi

pathModule="/usr/share/issabel/module_installer/%{name}-%{version}-%{release}"
# Run installer script to fix up ACLs and add module to Issabel menus.
issabel-menumerge /usr/share/issabel/module_installer/%{name}-%{version}-%{release}/menu.xml

pathSQLiteDB="/var/www/db"
mkdir -p $pathSQLiteDB
preversion=`cat $pathModule/preversion_%{modname}.info`
rm -f $pathModule/preversion_%{modname}.info

if [ $1 -eq 1 ]; then #install
  # The installer database
  issabel-dbprocess "install" "/usr/share/issabel/module_installer/%{name}-%{version}-%{release}/setup/db"
elif [ $1 -eq 2 ]; then #update
  # The installer database
   issabel-dbprocess "update"  "$pathModule/setup/db" "$preversion"
fi

#verificando si existe el menu en pbx
path="/var/www/db/acl.db"
path2="/var/www/db/menu.db"
id_menu="control_panel"

#obtenemos el id del recurso (EOP)
res=`sqlite3 $path "select id from acl_resource  where name='control_panel'"`

#obtenemos el id del grupo operador
opid=`sqlite3 $path "select id from acl_group  where name='Operator'"`

if [ $res ]; then #debe de existir el recurso EOP
   if [ $opid ]; then #debe de existir el grupo operador
      val=`sqlite3 $path "select * from acl_group_permission where id_group=$opid and id_resource=$res"`
      if [ -z $val ]; then #se pregunta si existe el permiso de EOP para el grupo Operador
         echo "updating group Operator with permissions in Control Panel Module"
	 `sqlite3 $path "insert into acl_group_permission(id_action, id_group, id_resource) values(1,$opid,$res)"`
      fi
   fi
fi

# The installer script expects to be in /tmp/new_module
mkdir -p /tmp/new_module/%{modname}
cp -r /usr/share/issabel/module_installer/%{name}-%{version}-%{release}/* /tmp/new_module/%{modname}/
chown -R asterisk.asterisk /tmp/new_module/%{modname}

php /tmp/new_module/%{modname}/setup/installer.php
rm -rf /tmp/new_module

# Detect need to fix up vsftpd configuration
if [ -e /tmp/vsftpd.user_list ] ; then
    echo "   NOTICE: fixing up vsftpd configuration..."
    # userlist_deny=NO
    sed --in-place "s,userlist_deny=NO,#userlist_deny=NO,g" /etc/vsftpd/vsftpd.conf
    rm -f /tmp/vsftpd.user_list
fi

# Remove old endpoints_batch menu item
issabel-menuremove endpoints_batch

chown asterisk.asterisk /var/www/html -R

%clean
rm -rf $RPM_BUILD_ROOT

%preun
if [ $1 -eq 0 ] ; then # Validation for desinstall this rpm; delete
pathModule="/usr/share/issabel/module_installer/%{name}-%{version}-%{release}"
  echo "Delete System menus"
  issabel-menuremove "pbxconfig"

  echo "Dump and delete %{name} databases"
  issabel-dbprocess "delete" "$pathModule/setup/db"
fi

%files
%defattr(-, asterisk, asterisk)
/etc/asterisk/sip_notify_custom_issabel.conf
# Los directorios /var/lib/asterisk/agi-bin y /var/lib/asterisk/moh NO se
# declaran: los provee asterisk22 como root:root 0755, y RPM no permite
# compartir un directorio si difieren el modo o el dueno. Declararlos aqui con
# asterisk:asterisk hacia que la instalacion abortara con
#   file /var/lib/asterisk/agi-bin conflicts with file from package asterisk22
# Se empaquetan solo los ficheros, que es lo que este paquete aporta.
/var/lib/asterisk/moh/*
/var/log/festival
/usr/share/issabel/module_installer/%{name}-%{version}-%{release}/setup/extensions_override_issabel.conf
/var/www/html/admin/issabel_issabelpbx_auth.php
%defattr(-, root, root)
%{_localstatedir}/www/html/*
/usr/share/issabel/module_installer/*
%defattr(644, root, root)
%config(noreplace) /etc/httpd/conf.d/*
%defattr(755, root, root)
/etc/init.d/festival
/usr/bin/asterisk.reload
/usr/share/issabel/privileged/*
/var/lib/asterisk/agi-bin/*
/etc/cron.daily/asterisk_cleanup

%changelog
* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-17
- Drop bootstrap-select from QR Configurations. Each combo box painted three
  arrows: bootstrap-select's own Bootstrap 3 caret, the Bootstrap 5
  .dropdown-toggle::after comes with the theme, and the .form-select
  background chevron that the widget copied from the select onto its wrapper
  div. The page now uses the theme controls: a native select for the phone
  brand and a text field with a datalist of the detected addresses for the
  host, which keeps the "add a hostname" ability without a Bootstrap 3
  widget on a Bootstrap 5 theme. bootstrap-select.js, bootstrap-select.css,
  javascript.js and custom.css are removed, so the module no longer loads
  85 KB of vendored code on every visit, and the lang/escapeQuote machinery
  that only served the widget is gone with them.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-16
- Stop the voicemail page from failing when the spool is missing.
  scandir() returns false when the directory cannot be opened, and passing
  false to array_filter() is a fatal TypeError in PHP 8: on a PBX without
  the voicemail context, where /var/spool/asterisk/voicemail/default does
  not exist, the module answered 500 instead of an empty list. The library
  now checks the directory and reports it, and the page shows the missing
  path as a warning. The unreadable mailbox and the missing voicemail.conf
  cases are guarded the same way. The French language file, the only one
  stored as ISO-8859-1, is converted to UTF-8, and the byte order mark that
  preceded the opening tag of the Persian one is removed so that including
  it does not emit output before the headers. file_editor and monitoring
  get the same guard for scandir() and glob().

* Tue Oct 20 2026 Issabel Foundation <info@issabel.org> - 6.0.0-15
- Bring the PBX pages onto the Modern form kit. asterisk_cli, file_editor,
  conference (filter), voicemail (filter), qr_batch and monitoring still used
  legacy tables, font tags and a Bootstrap 3 panel with hardcoded colors.
  They now use the theme grid, cards and the console primitive for command
  output. The file and voicemail filters no longer wrap a table inside the
  grid filter row. qr_batch drops the undefined panel-blue class and the
  glyphicon, and its stylesheet reads the theme tokens. The dead
  conference/wrapper.tpl template is removed. The Device label of the caller
  list is translated.

* Tue Oct 20 2026 Issabel Foundation <info@issabel.org> - 6.0.0-14
- Fix the defects found while auditing the PBX pages against STYLE.md.
  The voicemail configuration never painted its Save button (the Show flag
  was never assigned) and compared the two password fields before checking
  that they had been submitted. Conference regenerated the random conference
  number on every render. Monitoring emitted Bootstrap 3 font tags and
  inline colors, read a POST key that is absent on every page view, rendered
  the filter form twice and kept its styles in a template style block with
  hardcoded colors. qr_batch and extensions_batch dereferenced null when the
  Asterisk database was unreachable. Recordings, extensions_batch, festival,
  conference and file_editor reported their results through mb_title and
  mb_message, which the shell paints outside the module iframe, so the user
  never saw them; they now render a theme alert inside the page. Users
  without an extension got a blank page instead of an explanation. The
  remaining hardcoded Spanish and untranslated literals use language keys.

* Tue Oct 20 2026 Issabel Foundation <info@issabel.org> - 6.0.0-13
- Send the CSRF token with the PBX module forms. The form element lived in
  the PHP wrapper for conference, festival, recordings and voicemail, so
  issabelCsrf::injectField found no <form> to patch. The asterisk_cli
  template carried a commented-out <form> that swallowed the token, and
  qr_batch serves its templates with Smarty::fetch(), which skips the
  injector, so it prints the field explicitly. The dead form fallback in the
  voicemail grid is removed: paloSantoGrid always emits its own tokenized
  form.

* Fri Oct 16 2026 Issabel Foundation <info@issabel.org> - 6.0.0-12
- Escape the rpm queryformat used to record the pre-version on upgrade.
  The VERSION and RELEASE macros were expanded at build time, so %pre always
  wrote the new version and issabel-dbprocess skipped every version_sql
  migration. They are now escaped so rpm expands them at run time.

* Tue Oct 13 2026 Issabel Foundation <info@issabel.org> - 6.0.0-10
- Match the framework's default maximum of eight in-app tabs.

* Tue Oct 13 2026 Issabel Foundation <info@issabel.org> - 6.0.0-9
- Share the resolved PBX menu item with the embedded tab bridge.

* Tue Oct 13 2026 Issabel Foundation <info@issabel.org> - 6.0.0-8
- Pass the active tab context through the shared PBX authentication wrapper.

* Mon Oct 12 2026 Issabel Foundation <info@issabel.org> - 6.0.0-7
- Convert the monitoring filter form to the Modern form kit (labels above
  fields, section card, Show button on the card footer).

* Mon Oct 12 2026 Issabel Foundation <info@issabel.org> - 6.0.0-6
- Switch the monitoring filter to the Bootstrap 5 collapse attribute
  (data-bs-toggle); the BS3 data-toggle was ignored by the modern theme,
  leaving the Show Filter button dead.

* Sat Oct 10 2026 Issabel Foundation <info@issabel.org> - 6.0.0-4
- Monitoring: make the chart follow the dark theme (canvas background and
  Chart.js text/grid colours) and use the official brand purple (#572364).

* Thu Oct 08 2026 Issabel Foundation <info@issabel.org> - 6.0.0-2
- Stop declaring /var/lib/asterisk/agi-bin and /var/lib/asterisk/moh. asterisk22
  provides them as root:root 0755, and RPM rejects sharing a directory when the
  mode or owner differ, so installation failed with
  "file /var/lib/asterisk/agi-bin conflicts with file from package asterisk22".
- Package /var/lib/asterisk/moh/*. It had no entry in %files: the broad
  /var/lib/asterisk/* glob did not recurse, so the 6 MoH wav files were dropped
  from the package and rpmbuild aborted with unpackaged files
  (_unpackaged_files_terminate_build=1).
