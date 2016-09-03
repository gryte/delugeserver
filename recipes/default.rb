#
# Cookbook Name:: delugeserver
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'delugeserver::yum_setup'

# create system directories
directory '/.downloads' do
  owner 'root'
  group 'root'
end

# install deluge-daemon
package 'deluge' do
  action :install
  version "#{node['deluge']['version']}.#{node['deluge']['release']}.nux"
end

if node['deluge']['logs']['enabled']
  node.default['deluge']['daemon']['logs']['file'] = '-l /var/log/deluge/daemon.log'
  node.default['deluge']['daemon']['logs']['level'] = '-L warning'
  node.default['deluge']['web']['logs']['file'] = '-l /var/log/deluge/web.log'
  node.default['deluge']['web']['logs']['level'] = '-L warning'
  directory '/var/log/deluge' do
    owner 'deluge'
    group 'deluge'
    mode '750'
    action :create
  end
  template '/etc/logrotate.d/deluge' do
    source 'logrotate_deluge.erb'
    owner 'root'
    group 'root'
    mode '644'
  end
end

services = %w[deluged deluge-web]
services.each do |svc|
  template "/etc/systemd/system/#{svc}.service" do
    source "#{svc}.service.erb"
    owner 'root'
    group 'root'
    mode '644'
    notifies :restart, "service[#{svc}]", :delayed
  end
end

services.each do |svc|
  service "#{svc}" do
      action [ :enable, :start ]
  end
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
end

# manage label.conf file
template 'create_label.conf' do
  only_if { node['deluge']['config']['label.conf'] == true }
  notifies :stop, 'service[deluged]', :before
  action :create
  owner 'deluge'
  group 'deluge'
  path '/var/lib/deluge/.config/deluge/label.conf'
  source 'label.conf.erb'
  notifies :start, 'service[deluged]', :immediately
end

# manage core.conf file
if node['deluge']['config']['core.conf']['manage']
  node['deluge']['config']['core.conf']['settings'].each do |setting, value|
    execute 'set_config' do
      not_if "cat /var/lib/deluge/.config/deluge/core.conf | grep -w #{setting} | grep -w #{value}"
      command "sudo -u deluge deluge-console \"config -s #{setting} #{value}\""
    end
  end
end

# install plugins if not already enabled
node['deluge']['plugin']['enable'].each do |plugin|
  execute 'install_plugin' do
    not_if "sudo -u deluge deluge-console \"plugin -s\" | grep -w #{plugin}"
    command "sudo -u deluge deluge-console \"plugin -e #{plugin}\""
  end
end
