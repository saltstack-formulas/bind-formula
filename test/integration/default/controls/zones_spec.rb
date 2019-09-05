# Set defaults, use debian as base

conf_user       = 'bind'
conf_group      = 'bind'
keys_user       = 'root'
keys_group      = conf_group
logs_user       = 'root'
logs_group      = conf_group
named_directory = '/var/cache/bind'
zones_directory = '/var/cache/bind/zones'
keys_directory  = '/etc/bind/keys'
log_directory   = '/var/log/bind9'
keys_mode       = '02755'
conf_mode       = '0644'
config          = '/etc/bind/named.conf'

# Override by OS
case os[:name]
when 'arch','redhat', 'centos', 'fedora', 'amazon'
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
  zones_directory = nil   # not implemented
end

# Override log directory by OS
case os[:name]
when 'arch', 'ubuntu'
  log_directory   = '/var/log/named'
when 'redhat', 'centos', 'fedora', 'amazon'
  log_directory   = '/var/named/data'
end

if zones_directory

# Test example.com zonefile
control 'File ' + zones_directory + '/example.com' do
  title 'should exist'
  describe file(zones_directory + '/example.com') do
    its('owner') { should eq conf_user }
    its('group') { should eq conf_group }
    its('mode') { should cmp '0644' }
    # Multi line regex to match the various zones
    # If you're here to update the pillar/tests I would highly reccommend
    # using an online miltiline regex editor to do this:
    # https://www.regextester.com/
    # the #{foo} is a ruby string expansion so we can use the variables
    # defined above

    # Match SOA
    its('content') { should match /^@\ IN\ SOA\ ns1.example.com\ hostmaster.example.com\ \(\n    2018073100\ ;\ serial\n\ \ \ \ 12h\ ;\ refresh\n\ \ \ \ 600\ ;\ retry\n\ \ \ \ 2w\ ;\ expiry\n\ \ \ \ 1m\ ;\ nxdomain\ ttl\n\);/  }

    # Just match string for these as it's much easier to read
    # Match NS
    its('content') { should match '@ NS ns1' }
    # Match A
    its('content') { should match 'ns1 A 203.0.113.1' }
    its('content') { should match 'foo A 203.0.113.2' }
    its('content') { should match 'bar A 203.0.113.3' }
    # Match CNAME
    its('content') { should match 'ftp CNAME foo.example.com.' }
    its('content') { should match 'www CNAME bar.example.com.' }
    its('content') { should match 'mail CNAME mx1.example.com.' }
    its('content') { should match 'smtp CNAME mx1.example.com.' }
    # Match TXT
    its('content') { should match '@ TXT "some_value"' }
  end
end

# Test example.net zonefile
control 'File ' + zones_directory + '/example.net' do
  title 'should exist'
  describe file(zones_directory + '/example.net') do
    its('owner') { should eq conf_user }
    its('group') { should eq conf_group }
    its('mode') { should cmp '0644' }
    # Match SOA
    its('content') { should match /^@\ IN\ SOA\ ns1.example.net\ hostmaster.example.net\ \(\n\ \ \ \ [0-9]{10}\ ;\ serial\n\ \ \ \ 12h\ ;\ refresh\n\ \ \ \ 300\ ;\ retry\n\ \ \ \ 2w\ ;\ expiry\n\ \ \ \ 1m\ ;\ nxdomain\ ttl\n\);/  }
    # Match Include
    its('content') { should match /^\$INCLUDE\ #{zones_directory}\/example\.net\.include$/ }
  end
end

# Test example.net.include zonefile
control 'File ' + zones_directory + '/example.net.include' do
  title 'should exist'
  describe file(zones_directory + '/example.net.include') do
    its('owner') { should eq conf_user }
    its('group') { should eq conf_group }
    its('mode') { should cmp '0644' }
    # Just match string for these as it's much easier to read
    # Match NS
    its('content') { should match '@ NS ns1' }
    # Match A
    its('content') { should match 'ns1 A 198.51.100.1' }
    its('content') { should match 'foo A 198.51.100.2' }
    its('content') { should match 'bar A 198.51.100.3' }
    its('content') { should match 'baz A 198.51.100.4' }
    its('content') { should match 'mx1 A 198.51.100.5' }
    its('content') { should match 'mx1 A 198.51.100.6' }
    its('content') { should match 'mx1 A 198.51.100.7' }
    # Match CNAME
    its('content') { should match 'mail CNAME mx1.example.net.' }
    its('content') { should match 'smtp CNAME mx1.example.net.' }
  end
end

# Test 113.0.203.in-addr.arpa zonefile
control 'File ' + zones_directory + '/113.0.203.in-addr.arpa' do
  title 'should exist'
  describe file(zones_directory + '/113.0.203.in-addr.arpa') do
    its('owner') { should eq conf_user }
    its('group') { should eq conf_group }
    its('mode') { should cmp '0644' }
    # Match SOA
    its('content') { should match /^@\ IN\ SOA\ ns1.example.com\ hostmaster.example.com\ \(\n\ \ \ \ 2018073100\ ;\ serial\n\ \ \ \ 12h\ ;\ refresh\n\ \ \ \ 600\ ;\ retry\n\ \ \ \ 2w\ ;\ expiry\n\ \ \ \ 1m\ ;\ nxdomain\ ttl\n\);/  }

    # Just match string for these as it's much easier to read
    # Match Include
    its('content') { should match '1.113.0.203.in-addr.arpa PTR ns1.example.com.' }
    its('content') { should match '2.113.0.203.in-addr.arpa PTR foo.example.com.' }
    its('content') { should match '3.113.0.203.in-addr.arpa PTR bar.example.com.' }
  end
end

# Test 100.51.198.in-addr.arpa zonefile
control 'File ' + zones_directory + '/100.51.198.in-addr.arpa' do
  title 'should exist'
  describe file(zones_directory + '/100.51.198.in-addr.arpa') do
    its('owner') { should eq conf_user }
    its('group') { should eq conf_group }
    its('mode') { should cmp '0644' }
    # Match SOA
    its('content') { should match /^@\ IN\ SOA\ ns1.example.net\ hostmaster.example.net\ \(\n\ \ \ \ [0-9]{10}\ ;\ serial\n\ \ \ \ 12h\ ;\ refresh\n\ \ \ \ 600\ ;\ retry\n\ \ \ \ 2w\ ;\ expiry\n\ \ \ \ 1m\ ;\ nxdomain\ ttl\n\);/  }
    # Match Include
    its('content') { should match /^\$INCLUDE\ #{zones_directory}\/100\.51\.198\.in-addr\.arpa\.include$/ }
  end
end

# Test 100.51.198.in-addr.arpa.include zonefile
control 'File ' + zones_directory + '/100.51.198.in-addr.arpa.include' do
  title 'should exist'
  describe file(zones_directory + '/100.51.198.in-addr.arpa.include') do
    its('owner') { should eq conf_user }
    its('group') { should eq conf_group }
    its('mode') { should cmp '0644' }
    # Match PTR
    its('content') { should match '1.100.51.198.in-addr.arpa. PTR ns1.example.net.' }
    its('content') { should match '2.100.51.198.in-addr.arpa. PTR foo.example.net.' }
    its('content') { should match '3.100.51.198.in-addr.arpa. PTR bar.example.net.' }
    its('content') { should match '4.100.51.198.in-addr.arpa. PTR baz.example.net.' }
    its('content') { should match '5.100.51.198.in-addr.arpa. PTR mx1.example.net.' }
    its('content') { should match '6.100.51.198.in-addr.arpa. PTR mx1.example.net.' }
    its('content') { should match '7.100.51.198.in-addr.arpa. PTR mx1.example.net.' }
  end

end

end
