#
# Cookbook Name:: delugeserver
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# include_recipe 'firewall'
# enable platform default firewall
firewall 'default' do
  action :install
end

# install wget
package 'wget' do
  action :install
end

# install epel-release
package 'epel-release' do
  action :install
end

# create system directories
directory '/.downloads' do
  owner 'root'
  group 'root'
end

# download nux-dextop rpm
remote_file 'nux-dextop_download' do
  not_if { ::File.exist?('/.downloads/nux-dextop-release-0-5.el7.nux.noarch.rpm') }
  path '/.downloads/nux-dextop-release-0-5.el7.nux.noarch.rpm'
  source 'http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm'
end

# install nux-dextop
package 'nux-dextop' do
  source '/.downloads/nux-dextop-release-0-5.el7.nux.noarch.rpm'
  action :install
end

# install deluge-daemon
package 'deluge-daemon' do
  action :install
  notifies :create, 'template[create_systemd_deluged_service]', :immediately
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
  notifies :restart, 'service[deluged]', :immediately
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

# deluge-daemon service
service 'deluged' do
  action :enable
end

# install deluge-console
package 'deluge-console' do
  action :install
end

# manage deluge app directories
include_recipe 'delugeserver::app_directory'

# manage auth file
template 'create_auth' do
  only_if { node['deluge']['config']['auth'] == true }
  action :create
  owner 'deluge'
  group 'deluge'
  path '/var/lib/deluge/.config/deluge/auth'
  source 'auth.erb'
  notifies :restart, 'service[deluged]', :delayed
  variables(
    env: node.chef_environment
  )
end

# manage label.conf file
template 'create_label.conf' do
  only_if { node['deluge']['config']['label.conf'] == true }
  notifies :stop, 'service[deluged]', :before
  action :create_if_missing
  owner 'deluge'
  group 'deluge'
  path '/var/lib/deluge/.config/deluge/label.conf'
  source 'label.conf.erb'
  notifies :start, 'service[deluged]', :immediately
end

# install unrar
package 'unrar' do
  action :install
end

# manage core.conf file
if node['deluge']['config']['core.conf']['manage']
  node['deluge']['config']['core.conf']['settings'].each do |setting, value|
    execute "set_config_#{setting}" do
      not_if "cat /var/lib/deluge/.config/deluge/core.conf | grep -w #{setting} | grep -w #{value}"
      command "sudo -u deluge deluge-console \"config -s #{setting} #{value}\""
    end
  end
end

# install plugins if not already enabled
unless node['deluge']['plugin']['enable'].empty?
  node['deluge']['plugin']['enable'].each do |plugin|
    execute "install_plugin_#{plugin}" do
      not_if "sudo -u deluge deluge-console \"plugin -s\" | grep -w #{plugin}"
      command "sudo -u deluge deluge-console \"plugin -e #{plugin}\""
    end
  end
end

# open port to deluge-web service
firewall_rule 'deluge-web' do
  port 8112
  command :allow
end

# open port to deluged service
firewall_rule 'deluged' do
  port 58846
  command :allow
end

# open ports for deluge incoming tcp connections
firewall_rule 'deluge-incoming-tcp' do
  protocol :tcp
  port 6881..6891
  command :allow
end

# open ports for deluge incoming udp connections
firewall_rule 'deluge-incoming-udp' do
  protocol :udp
  port 6881..6891
  command :allow
end

# open port for ssh connections
firewall_rule 'ssh' do
  port 22
  command :allow
end
