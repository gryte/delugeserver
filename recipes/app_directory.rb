# create directories from attribute list
node['deluge']['app']['directories'].each do |dir, perms|
  directory dir.to_s do
    owner perms['owner'].to_s
    group perms['group'].to_s
  end
end
