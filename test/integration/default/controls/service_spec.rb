# frozen_string_literal: true

case os[:name]
when 'arch', 'redhat', 'centos', 'fedora', 'amazon'
  service = 'named'
when 'suse', 'opensuse'
  service = 'named'
when 'debian', 'ubuntu'
  service = 'bind9'
end

control 'Bind9 service' do
  title 'should be running'

  describe service(service) do
    #    it { should be_enabled }
    it { should be_running }
  end
end
