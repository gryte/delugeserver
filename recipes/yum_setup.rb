#
# Cookbook Name:: delugeserver
# Recipe:: yum_setup
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'yum'
include_recipe 'yum-epel'

yum_repository 'Nux_Dextop' do
  description 'Nux Dextop Repo'
  baseurl "http://li.nux.ro/download/nux/dextop/el7/$basearch/ http://mirror.li.nux.ro/li.nux.ro/nux/dextop/el7/$basearch/"
  gpgkey 'http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro'
  action :create
end