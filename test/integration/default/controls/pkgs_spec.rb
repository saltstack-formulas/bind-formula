
case os[:name]
when 'arch'
  os_packages = %w(
    bind
    bind-tools
    dnssec-tools
  )
when 'redhat', 'centos', 'fedora', 'amazon'
  os_packages = %w(bind)
when 'suse', 'opensuse'
  os_packages = %w(bind)
when 'debian', 'ubuntu'
  os_packages = %w(
    bind9
    bind9utils
  )
end

control 'Bind9 packages' do
  title 'should be installed'

  os_packages.each do |p|
    describe package(p) do
      it { should be_installed }
    end
  end
end

