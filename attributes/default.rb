# manage auth file users
default['config']['auth'] = false

# manage configuration files
default['config']['core.conf']['manage'] = false
default['config']['core.conf']['settings'] = {}
default['config']['label.conf'] = false

# manage plugins
default['plugin']['enable'] = ['']

# manage directory creation
default['app']['directories'] = {
  '/.deluge' => {
    'owner' => 'deluge',
    'group' => 'deluge'
  },
  '/.deluge/staging' => {
    'owner' => 'deluge',
    'group' => 'deluge'
  },
  '/.deluge/prep' => {
    'owner' => 'deluge',
    'group' => 'deluge'
  },
  '/.deluge/complete' => {
    'owner' => 'deluge',
    'group' => 'deluge'
  },
  '/.deluge/complete/tv' => {
    'owner' => 'deluge',
    'group' => 'deluge'
  },
  '/.deluge/complete/movie' => {
    'owner' => 'deluge',
    'group' => 'deluge'
  },
}
