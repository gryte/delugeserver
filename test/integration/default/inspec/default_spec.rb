# wget is installed
describe package('wget') do
  it { should be_installed }
end

# epel-release is installed
describe package('epel-release') do
  it { should be_installed }
end

# downloads directory exists
describe directory('/.downloads') do
  it { should be_directory }
end

# nux-dextop exists
describe file('/.downloads/nux-dextop-release-0-5.el7.nux.noarch.rpm') do
  it { should be_file }
end

# nux-desktop is installed
describe command('rpm -V nux-dextop-release-0-5.el7.nux.noarch') do
  its('stdout') { should eq '' }
end

# deluge-web is installed
describe package('deluge-web') do
  it { should be_installed }
  its('version') { should eq '1.3.11-1.el7.nux' }
end

# deluge-web service is enabled and running
describe service('deluge-web') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# /.deluge directory exists
describe directory('/.deluge') do
  it { should be_directory }
  it { should be_owned_by 'deluge' }
  it { should be_grouped_into 'deluge' }
end

# /.deluge/prep directory exists
describe directory('/.deluge/prep') do
  it { should be_directory }
  it { should be_owned_by 'deluge' }
  it { should be_grouped_into 'deluge' }
end

# /.deluge/staging directory exists
describe directory('/.deluge/staging') do
  it { should be_directory }
  it { should be_owned_by 'deluge' }
  it { should be_grouped_into 'deluge' }
end

# /.deluge/complete directory exists
describe directory('/.deluge/complete') do
  it { should be_directory }
  it { should be_owned_by 'deluge' }
  it { should be_grouped_into 'deluge' }
end

# /.deluge/complete/tv directory exists
describe directory('/.deluge/complete/tv') do
  it { should be_directory }
  it { should be_owned_by 'deluge' }
  it { should be_grouped_into 'deluge' }
end

# /.deluge/complete/movie directory exists
describe directory('/.deluge/complete/movie') do
  it { should be_directory }
  it { should be_owned_by 'deluge' }
  it { should be_grouped_into 'deluge' }
end

# deluged is installed
describe package('deluge-daemon') do
  it { should be_installed }
  its('version') { should eq '1.3.11-1.el7.nux' }
end

# deluged.service exists
describe file('/etc/systemd/system/deluged.service') do
  it { should be_file }
end

# deluge-web.service exists
describe file('/etc/systemd/system/deluge-web.service') do
  it { should be_file }
end

# deluge-web service is enabled and running
describe service('deluged') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# deluge-console is installed
describe package('deluge-console') do
  it { should be_installed }
end

# auth file exists
describe file('/var/lib/deluge/.config/deluge/auth') do
  it { should be_file }
  its('content') { should match '^localclient.*$' }
  its('content') { should match '^sonarrserver:fakesonarrpw:10$' }
  its('content') { should match '^couchserver:fakecouchpw:10$' }
end

# core.conf file exists
describe file('/var/lib/deluge/.config/deluge/core.conf') do
  it { should be_file }
  its('content') { should match '"allow_remote": true,' }
  its('content') { should match '"move_completed_path": "/\.deluge/complete",' }
  its('content') { should match '"utpex": false,' }
  its('content') { should match '"download_location": "/\.deluge/staging",' }
  its('content') { should match '"dht": false,' }
  its('content') { should match '"move_completed": true,' }
  its('content') { should match '"lsd": false,' }
  its('content') { should match '"random_port": false,' }
end

# label.conf file exists
describe file('/var/lib/deluge/.config/deluge/label.conf') do
  it { should be_file }
  its('content') { should match '.*"move_completed_path": "/\.deluge/complete/tv",' }
  its('content') { should match '.*"move_completed_path": "/\.deluge/complete/movie",' }
end

# Plugin AutoAdd is enabled
describe command('sudo -u deluge deluge-console "plugin -s" | grep AutoAdd') do
  its('stdout') { should match 'AutoAdd' }
end

# Plugin Label is enabled
describe command('sudo -u deluge deluge-console "plugin -s" | grep Label') do
  its('stdout') { should match 'Label' }
end

# extractor.conf file exists
describe file('/var/lib/deluge/.config/deluge/extractor.conf') do
  it { should be_file }
end

# Plugin Extractor is enabled
describe command('sudo -u deluge deluge-console "plugin -s" | grep Extractor') do
  its('stdout') { should match 'Extractor' }
end

# unrar is installed
describe package('unrar') do
  it { should be_installed }
end

# firewalld service is enabled and running
describe service('firewalld') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# deluge-web port 8112 is listening
describe port(8_112) do
  it { should be_listening }
end

# deluge-web port 8112 is listening
describe port(58_846) do
  it { should be_listening }
end

# deluge network incoming tcp ports are listening
describe port.where { protocol =~ /tcp/ && port > 6880 && port < 6892 } do
  it { should be_listening }
end

# deluge network incoming udp ports are listening
describe port.where { protocol =~ /udp/ && port > 6880 && port < 6892 } do
  it { should be_listening }
end

# iptables is configured
describe iptables(chain: 'INPUT_direct') do
  it { should have_rule('-A INPUT_direct -p tcp -m tcp -m multiport --dports 22 -m comment --comment ssh -j ACCEPT') }
  it { should have_rule('-A INPUT_direct -p tcp -m tcp -m multiport --dports 8112 -m comment --comment deluge-web -j ACCEPT') }
  it { should have_rule('-A INPUT_direct -p tcp -m tcp -m multiport --dports 58846 -m comment --comment deluged -j ACCEPT') }
  it { should have_rule('-A INPUT_direct -p tcp -m tcp -m multiport --dports 6881:6891 -m comment --comment deluge-incoming-tcp -j ACCEPT') }
  it { should have_rule('-A INPUT_direct -p udp -m multiport --dports 6881:6891 -m comment --comment deluge-incoming-udp -j ACCEPT') }
end
