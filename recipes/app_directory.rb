# create directories from attribute list
node['deluge']['app']['directories'].each do |dir, perms|
  directory "#{dir}" do
    owner "#{perms['owner']}"
    group "#{perms['group']}"
  end
end
