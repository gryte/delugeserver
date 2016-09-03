# Nux_Dextop repo exists
describe yum.repo('Nux_Dextop') do
  it { should exist }
  it { should be_enabled }
end

# Epel repo exists
describe yum.repo('epel') do
  it { should exist }
  it { should be_enabled }
end

# deluge-web is installed
describe package('deluge-web') do
  it { should be_installed }
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
  its('content') { should match "^localclient.*$" }
  its('content') { should match "^sonarrserver:fakesonarrpw:10$" }
  its('content') { should match "^couchserver:fakecouchpw:10$" }
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
end

# label.conf file exists
describe file('/var/lib/deluge/.config/deluge/label.conf') do
  it { should be_file }
  its('content') { should match '.*"move_completed_path": "/\.deluge/complete/tv",' }
  its('content') { should match '.*"move_completed_path": "/\.deluge/complete/movie",' }
end

# Plugin AutoAdd is enabled
describe command('sudo -u deluge deluge-console "plugin -s" | grep AutoAdd') do
  its('stdout') { should match "AutoAdd" }
end

# Plugin Label is enabled
describe command('sudo -u deluge deluge-console "plugin -s" | grep Label') do
  its('stdout') { should match "Label" }
end


