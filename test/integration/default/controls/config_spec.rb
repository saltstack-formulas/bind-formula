# frozen_string_literal: true
# Set defaults, use debian as base

conf_user       = 'bind'
conf_group      = 'bind'
keys_user       = 'root'
keys_group      = conf_group
logs_user       = 'root'
logs_group      = conf_group
logs_mode       = '0775'
named_directory = '/var/cache/bind'
zones_directory = '/var/cache/bind/zones'
keys_directory  = '/etc/bind/keys'
log_directory   = '/var/log/bind9'
keys_mode       = '02755'
conf_mode       = '0644'
config          = '/etc/bind/named.conf'

# Override by OS
case os[:name]
when 'arch', 'redhat', 'centos', 'fedora', 'amazon'
  conf_user       = 'named'
  conf_group      = 'named'
  keys_group      = 'root'
  logs_group      = conf_group
  named_directory = '/var/named'
  zones_directory = named_directory
  keys_directory  = '/etc/named.keys'
  keys_mode       = '0755'
  conf_mode       = '0640'
  config          = '/etc/named.conf'
when 'suse', 'opensuse'
   conf_user       = 'root'
  conf_group      = 'named'
  logs_user       = 'root'
  logs_group      = 'root'
  logs_mode       = '0755'
  keys_group      = 'root'
  logs_group      = 'root'
  named_directory = '/var/lib/named'
  zones_directory = '/var/lib/named'
  keys_directory  = '/etc/named.keys'
  keys_mode       = '0755'
  conf_mode       = '0640'
  config          = '/etc/named.d/named.conf'
end

# Override log directory by OS
case os[:name]
when 'arch', 'ubuntu'
  log_directory = '/var/log/named'
when 'redhat', 'centos', 'fedora', 'amazon'
  log_directory = '/var/named/data'
when 'suse', 'opensuse'
  log_directory = '/var/log'
end

# Check main config dir
control 'Directory ' + named_directory do
  title 'should exist'
  describe directory(named_directory) do
    its('owner') { should eq conf_user }
    its('group') { should eq conf_group }
    its('mode')  { should cmp '0775' }
  end
end

# Check DNSSEC keys dir
control 'Directory ' + keys_directory do
  title 'should exist'
  describe directory(keys_directory) do
    its('owner') { should eq keys_user }
    its('group') { should eq keys_group }
    its('mode')  { should cmp keys_mode }
  end
end

# Check Logs dir
control 'Directory ' + log_directory do
  title 'should exist'
  describe directory(log_directory) do
    its('owner') { should eq logs_user }
    its('group') { should eq logs_group }
    its('mode')  { should cmp logs_mode }
  end
end

# Check zones dir if on debian based OS
control 'Directory ' + zones_directory do
  title 'should exist'
  only_if do
    os.debian?
  end
  describe directory(zones_directory) do
    its('owner') { should eq conf_user }
    its('group') { should eq conf_group }
    its('mode')  { should cmp '0775' }
  end
end

# Check main config
# RHEL: Doesn't use .options and has rfc1912.zones
# Debian: Uses .options
case os[:name]
when 'arch', 'redhat', 'centos', 'fedora', 'amazon'
  control 'File ' + config do
      title 'should exist'
    describe file(config) do
        its('owner') { should eq conf_user }
      its('group') { should eq conf_group }
      its('mode') { should cmp conf_mode }
      its('content') { should match %r{^include\ "/etc/named\.rfc1912\.zones";} }
      its('content') { should match %r{^include\ "/etc/named\.conf\.local";} }
    end
  end
when 'ubuntu', 'debian'
  control 'File ' + config do
      title 'should exist'
    describe file(config) do
        its('owner') { should eq conf_user }
      its('group') { should eq conf_group }
      its('mode') { should cmp conf_mode }
      its('content') { should match %r{^include\ "/etc/bind/named\.conf\.local";} }
      its('content') { should match %r{^include\ "/etc/bind/named\.conf\.options";} }
    end
  end
end

# If debian check the .options file
control 'File ' + config + '.options' do
  title 'should exist'
  only_if do
    os.debian?
  end
  describe file(config + '.options') do
    its('owner') { should eq conf_user }
    its('group') { should eq conf_group }
    its('mode') { should cmp '0644' }
    its('content') { should match /\ {8}directory\ "#{named_directory}"/ }
    its('content') { should match /\ {8}key-directory\ "#{keys_directory}"/ }
  end
end

# Check config.local
control 'File ' + config + '.local' do
  title 'should exist'
  describe file(config + '.local') do
    its('owner') { should eq conf_user }
    its('group') { should eq conf_group }
    its('mode') { should cmp '0644' }
    # Multi line regex to match the various zones
    # If you're here to update the pillar/tests I would highly reccommend
    # using an online miltiline regex editor to do this:
    # https://www.regextester.com/
    # the #{foo} is a ruby string expansion so we can use the variables
    # defined above
    # Match example.com zone from the pillar
    its('content') { should match /^zone\ "example\.com"\ {\n\ \ type\ master;\n\ \ file\ "#{zones_directory}\/example\.com";\n\ \ \n\ \ update-policy\ {\n\ \ \ \ grant\ core_dhcp\ name\ dns_entry_allowed_to_update\.\ ANY;\n\ \ \};\n\ \ notify\ no;\n\};/ }
    # Match example.net from pillar
    its('content') { should match /^zone\ "example\.net"\ {\n\ \ type\ master;\n\ \ file\ "#{zones_directory}\/example\.net";\n\ \ \n\ \ notify\ no;\n\};/ }
    # Match example.org from pillar
    its('content') { should match /^zone\ "example\.org"\ {\n\ \ type\ slave;\n\ \ file\ "#{zones_directory}\/";\n\ \ \n\ \ notify\ no;\n\ \ masters\ \{\n\ \ \ \ 192\.0\.2\.1;\n\ \ \ \ 192\.0\.2\.2;\n\ \ \};\n\};/ }
    # Match 113.0.203 reverse zone from pillar
    its('content') { should match /^zone\ "113\.0\.203\.in-addr\.arpa"\ {\n\ \ type\ master;\n\ \ file\ "#{zones_directory}\/113\.0\.203\.in-addr\.arpa";\n\ \ \n\ \ notify\ no;\n\};/ }
    # Match 100.51.198 reverse zone from pillar
    its('content') { should match /^zone\ "100\.51\.198\.in-addr\.arpa"\ {\n\ \ type\ master;\n\ \ file\ "#{zones_directory}\/100\.51\.198\.in-addr\.arpa";\n\ \ \n\ \ notify\ no;\n\};/ }
    # Match logging
    its('content') { should match /^logging\ \{\n\ \ channel\ "querylog"\ {\n\ \ \ \ file\ "#{log_directory}\/query\.log";\n\ \ \ \ print-time\ yes;\n\ \ \};\n\ \ category\ queries\ \{\ querylog;\ \};\n\};/ }
    # Match acl1
    its('content') { should match /acl\ client1\ \{\n\ \ 127\.0\.0\.0\/8;\n\ \ 10\.20\.0\.0\/16;\n\};/ }
    # Match acl2
    its('content') { should match /acl\ client2\ \{\n\ \ 10\.0\.0\.0\/8;\n\ \ 10\.30\.0\.0\/16;\n\};/ }
  end
end
