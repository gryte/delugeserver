# manage auth file users
default['config']['auth'] = false

# manage configuration files
default['config']['core.conf']['manage'] = false
default['config']['core.conf']['settings'] = {
  'move_completed_path' => '/.deluge/complete',
  'move_completed' => 'true',
  'allow_remote' => 'true',
  'download_location' => '/.deluge/staging',
  'utpex' => 'false',
  'dht' => 'false',
}
default['config']['label.conf'] = false

# manage plugins
default['plugin']['enable'] = ['']
