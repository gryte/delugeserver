#
# Cookbook Name:: delugeserver
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# install wget
package 'wget' do
  action :install
end

# install epel-release
package 'epel-release' do
  action :install
end

# create downloads directory
directory '/.downloads' do
  owner 'root'
  group 'root'
  action :create
end

# download nux-dextop rpm
execute 'nux-dextop_download' do
  not_if do ::File.exists?('/.downloads/nux-dextop-release-0-5.el7.nux.noarch.rpm') end
  command 'wget http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm -P /.downloads/'
  action :run
end

# install nux-dextop
package 'nux-dextop' do
  source '/.downloads/nux-dextop-release-0-5.el7.nux.noarch.rpm'
  action :install
end

# install deluge-web
package 'deluge-web' do
  action :install
end

# create deluged.service file
template 'create_systemd_deluged_service' do
  action :create
  path '/etc/systemd/system/deluged.service'
  source 'deluged.service.erb'
  owner 'root'
  group 'root'
  mode '0755'
  notifies :restart, 'service[deluged]', :delayed
end

# create deluge-web.service file
template 'create_systemd_deluge-web_service' do
  action :create
  path '/etc/systemd/system/deluge-web.service'
  source 'deluge-web.service.erb'
  owner 'root'
  group 'root'
  mode '0755'
  notifies :restart, 'service[deluge-web]', :delayed
end

# deluge-web service
service 'deluge-web' do
  action :enable
end

# create /.deluge directory
directory 'create_delugedir' do
  path '/.deluge'
  owner 'deluge'
  group 'deluge'
  action :create
end

# create /.deluge/staging directory
directory 'create_deluge_stagedir' do
  path '/.deluge/staging'
  owner 'deluge'
  group 'deluge'
  action :create
end

# create /.deluge/prep directory
directory 'create_deluge_prepdir' do
  path '/.deluge/prep'
  owner 'deluge'
  group 'deluge'
  action :create
end

# create /.deluge/complete directory
directory 'create_deluge_completedir' do
  path '/.deluge/complete'
  owner 'deluge'
  group 'deluge'
  action :create
end

# create /.deluge/complete/tv directory
directory 'create_deluge_complete_tvdir' do
  path '/.deluge/complete/tv'
  owner 'deluge'
  group 'deluge'
  action :create
end

# create /.deluge/complete/movie directory
directory 'create_deluge_complete_moviedir' do
  path '/.deluge/complete/movie'
  owner 'deluge'
  group 'deluge'
  action :create
end

# create /var/lib/deluge/.config directory
directory 'create_deluge_.config_delugedir' do
  path '/var/lib/deluge/.config'
  owner 'deluge'
  group 'deluge'
  action :create
end

# create /var/lib/deluge/.config/deluge directory
directory 'create_deluge_.config_delugedir' do
  path '/var/lib/deluge/.config/deluge'
  owner 'deluge'
  group 'deluge'
  action :create
end

# install deluge-daemon
package 'deluge-daemon' do
  action :install
  notifies :start, 'service[deluged]', :delayed
end

# deluge-daemon service
service 'deluged' do
  action :enable
end

# install deluge-console
package 'deluge-console' do
  action :install
end

# manage auth file
template 'create_auth' do
  only_if { node['config']['auth'] == true }
  action :create
  path '/var/lib/deluge/.config/deluge/auth'
  source 'auth.erb'
  notifies :restart, 'service[deluged]', :delayed
end

# manage core.conf file
template 'create_core.conf' do
  only_if { node['config']['core.conf'] == true }
  notifies :stop, 'service[deluged]', :before
  action :create
  path '/var/lib/deluge/.config/deluge/core.conf'
  source 'core.conf.erb'
  notifies :start, 'service[deluged]', :immediately
end

# manage label.conf file
template 'create_label.conf' do
  only_if { node['config']['label.conf'] == true }
  notifies :stop, 'service[deluged]', :before
  action :create
  path '/var/lib/deluge/.config/deluge/label.conf'
  source 'label.conf.erb'
  notifies :start, 'service[deluged]', :immediately
end

# install plugins if not already enabled
node['plugin']['enable'].each do |plugin|
  execute 'install_plugin' do
    not_if "sudo -u deluge deluge-console \"plugin -s\" | grep #{plugin}"
    command "sudo -u deluge deluge-console \"plugin -e #{plugin}\""
  end
end
