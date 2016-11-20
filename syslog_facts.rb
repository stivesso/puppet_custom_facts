# The aim here is to have a set of Custom Facts related to Syslog Daemons
# Check for now the Syslog(s) versions Installed, the running daemon and the version of that running daemon
# Inspired by https://github.com/loggly/Loggly-Puppet Custom Facts
# Written by stivesso (github.com/stivesso)

Facter.add("syslog_daemon_installed") do
    setcode do
        distid = Facter.value('osfamily')
        syslog_daemon = {}
        case distid
        when /RedHat|Suse/
          syslog_ng_installed = Facter::Util::Resolution.exec('/bin/rpm -q syslog-ng 2>/dev/null | /bin/grep -c ^syslog-ng')
          rsyslog_installed   = Facter::Util::Resolution.exec('/bin/rpm -q rsyslog 2>/dev/null | /bin/grep -c ^rsyslog')
          syslog_installed    = Facter::Util::Resolution.exec('/bin/rpm -q sysklogd 2>/dev/null | /bin/grep -c ^sysklogd')
          syslog_daemon = {'syslog-ng' => syslog_ng_installed, 'rsyslogd' => rsyslog_installed, 'syslogd' => syslog_installed}  
        when /Debian/
          syslog_ng_installed = Facter::Util::Resolution.exec('/usr/bin/dpkg-query -W -f \'${status}\' syslog-ng 2>/dev/null | /bin/grep -c ^install')
          rsyslog_installed   = Facter::Util::Resolution.exec('/usr/bin/dpkg-query -W -f \'${status}\' rsyslog 2>/dev/null | /bin/grep -c ^install')
          syslog_installed    = Facter::Util::Resolution.exec('/usr/bin/dpkg-query -W -f \'${status}\' syslog 2>/dev/null | /bin/grep -c ^install')
          syslog_daemon = {'syslog-ng' => syslog_ng_installed, 'rsyslogd' => rsyslog_installed, 'syslogd' => syslog_installed}  
        else
          syslog_daemon = {}
        end
    end
end

Facter.add("syslog_running") do
    setcode do
          syslog_ng_running   = Facter::Util::Resolution.exec('/bin/ps -e | /bin/awk \'{print $4}\' | /bin/grep -c "^syslog-ng$"')
          rsyslog_running     = Facter::Util::Resolution.exec('/bin/ps -e | /bin/awk \'{print $4}\' | /bin/grep -c "^rsyslogd$"')
          syslog_running      = Facter::Util::Resolution.exec('/bin/ps -e | /bin/awk \'{print $4}\' | /bin/grep -c "^syslogd$"')
          if syslog_ng_running != "0"
            syslog_running =  "syslog-ng"
          elsif rsyslog_running != "0"
            syslog_running =  "rsyslogd"
          elsif syslog_running != "0"
            syslog_running =  "syslogd"
          else
            syslog_running = "NA"
          end
    end
end

Facter.add("syslog_running_version") do
    setcode do
        s_running = Facter.value('syslog_running')
        if s_running == "syslog-ng"
            syslog_running_version = Facter::Util::Resolution.exec("syslog-ng -V | head -n1 | awk '{ print $2 }'")
        elsif s_running == "rsyslogd"
            syslog_running_version = Facter::Util::Resolution.exec("rsyslogd -v | head -n1 | awk '{ print $2 }' | sed 's/,//'")
        elsif s_running == "syslogd"
            syslog_running_version = Facter::Util::Resolution.exec("syslogd -v | head -n1 | awk '{ print $2 }' | sed 's/,//'")
        else
            syslog_running_version = "NA"
        end
    end
end

