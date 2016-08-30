# create directories from attribute list
node['app']['directories'].each do |dir, perms|
  directory "#{dir}" do
    owner "#{perms['owner']}"
    group "#{perms['group']}"
  end
end
