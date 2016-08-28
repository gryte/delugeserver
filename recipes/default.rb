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
  notifies :create, 'template[create_systemd_deluge-web_service]', :immediately
  notifies :run, 'execute[enable_deluge-web]', :immediately
  notifies :start, 'service[deluge-web]', :immediately
  notifies :create, 'template[create_systemd_deluged_service]', :immediately
  notifies :run, 'execute[enable_deluged]', :immediately
  notifies :start, 'service[deluged]', :immediately
  notifies :create, 'directory[create_delugedir]', :immediately
  notifies :create, 'directory[create_deluge_stagedir]', :immediately
  notifies :create, 'directory[create_deluge_prepdir]', :immediately
  notifies :create, 'directory[create_deluge_completedir]', :immediately
  notifies :create, 'directory[create_deluge_complete_tvdir]', :immediately
  notifies :create, 'directory[create_deluge_complete_moviedir]', :immediately
end

# create deluged.service file
template 'create_systemd_deluged_service' do
  action :nothing
  path '/etc/systemd/system/deluged.service'
  source 'deluged.service.erb'
  owner 'root'
  group 'root'
  mode '0755'
  notifies :restart, 'service[deluged]', :immediately
end

# create deluge-web.service file
template 'create_systemd_deluge-web_service' do
  action :nothing
  path '/etc/systemd/system/deluge-web.service'
  source 'deluge-web.service.erb'
  owner 'root'
  group 'root'
  mode '0755'
  notifies :restart, 'service[deluge-web]', :immediately
end

# enable deluge-web service
execute 'enable_deluge-web' do
  command 'systemctl enable deluge-web'
  action :nothing
end

# deluge-web service
service 'deluge-web' do
  action :nothing
end

# create /.deluge directory
directory 'create_delugedir' do
  path '/.deluge'
  owner 'deluge'
  group 'deluge'
  action :nothing
end

# create /.deluge/staging directory
directory 'create_deluge_stagedir' do
  path '/.deluge/staging'
  owner 'deluge'
  group 'deluge'
  action :nothing
end

# create /.deluge/prep directory
directory 'create_deluge_prepdir' do
  path '/.deluge/prep'
  owner 'deluge'
  group 'deluge'
  action :nothing
end

# create /.deluge/complete directory
directory 'create_deluge_completedir' do
  path '/.deluge/complete'
  owner 'deluge'
  group 'deluge'
  action :nothing
end

# create /.deluge/complete/tv directory
directory 'create_deluge_complete_tvdir' do
  path '/.deluge/complete/tv'
  owner 'deluge'
  group 'deluge'
  action :nothing
end

# create /.deluge/complete/movie directory
directory 'create_deluge_complete_moviedir' do
  path '/.deluge/complete/movie'
  owner 'deluge'
  group 'deluge'
  action :nothing
end

# install deluge-daemon
package 'deluge-daemon' do
  action :install
  notifies :run, 'execute[enable_deluged]', :immediately
  notifies :start, 'service[deluged]', :immediately
end

# enable deluge-daemon service
execute 'enable_deluged' do
  command 'systemctl enable deluged'
  action :nothing
end

# deluge-daemon service
service 'deluged' do
  action :nothing
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
  notifies :restart, 'service[deluged]', :immediately
end

if node['config']['core.conf'] == true
  # manage core.conf file
  template 'create_core.conf' do
    notifies :stop, 'service[deluged]', :before
    action :create
    path '/var/lib/deluge/.config/deluge/core.conf'
    source 'core.conf.erb'
    notifies :start, 'service[deluged]', :immediately
  end
end

if node['config']['label.conf'] == true
  # manage label.conf file
  template 'create_label.conf' do
    notifies :stop, 'service[deluged]', :before
    action :create
    path '/var/lib/deluge/.config/deluge/label.conf'
    source 'label.conf.erb'
    notifies :start, 'service[deluged]', :immediately
  end
end

# install plugins
node['plugin']['enable'].each do |plugin|
  execute 'install_plugin' do
    command "sudo -u deluge deluge-console \"plugin -e #{plugin}\""
  end
end
