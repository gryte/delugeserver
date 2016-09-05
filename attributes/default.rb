# manage auth file users
default['deluge']['config']['auth'] = false

# manage configuration files
default['deluge']['config']['core.conf']['manage'] = false
default['deluge']['config']['core.conf']['settings'] = {}
default['deluge']['config']['label.conf'] = false

# manage plugins
default['deluge']['plugin']['enable'] = []

# manage directory creation
default['deluge']['app']['directories'] = {
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
