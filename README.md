# puppet_custom_facts
Some Puppet Custom Facts that may be useful

## **syslog_facts.rb:**  

  _# Contains a set Custom Facts related to Syslog Daemons.  
  Check for now the Syslog(s) versions Installed, the running daemon and the version of that running daemon.  
  Inspired by https://github.com/loggly/Loggly-Puppet Custom Facts  
  Written by stivesso (github.com/stivesso)_
    
### Sample Output for syslog_facts.rb
```sh
# facter -p syslog_running
rsyslogd
# facter -p syslog_running_version
5.8.10
# facter -p syslog_daemon_installed
{
  syslog-ng => "0",
  rsyslogd => "1",
  syslogd => "0"
}
```
