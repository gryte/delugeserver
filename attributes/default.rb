#General settings
default['deluge']['version'] = '1.3.12-1'
default['deluge']['release'] = 'el7'

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

# Logging
default['deluge']['logs']['enabled'] = true
default['deluge']['daemon']['logs']['file'] = ''
default['deluge']['daemon']['logs']['level'] = ''

default['deluge']['web']['logs']['file'] = ''
default['deluge']['web']['logs']['level'] = ''
