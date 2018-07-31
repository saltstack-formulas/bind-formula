
case os[:name]
when 'arch','redhat', 'centos', 'fedora'
  service = 'named'
when 'debian', 'ubuntu'
  service = 'bind9'
end

control 'Bind9 service' do
  title 'should be running'

  describe service(service) do
    it { should be_enabled }
    it { should be_running }
  end
end
