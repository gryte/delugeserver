#
#    manage auth file users
#
# If set to true, then the cookbook will create the file
# /var/lib/deluge/.config/deluge/auth based on the auth.erb which requires an
# encrypted data bag 'auth'. Please see test/integration/data_bags/auth for an
# example.
#
default['deluge']['config']['auth'] = false

#
#    manage configuration files
#
# This will create and update the files /var/lib/deluge/.config/deluge/core.conf
# and /var/lib/deluge/.config/deluge/label.conf. The core.conf file is updated
# with items from 'settings' via the deluge-console. The label.conf is hard-coded
# with a label.conf.erb file and requires the current values specified in 'directories'.
# See .kitchen.yml for examples.
#
default['deluge']['config']['core.conf']['manage'] = false
default['deluge']['config']['core.conf']['settings'] = {}
default['deluge']['config']['label.conf'] = false

#
#    manage plugins
#
# List of plugins to enable via the deluge-console. The label.conf file is directly
# related to this attribute (meaning there's no point configuring the label plugin
# if you don't actually enable it).
# See .kitchen.yml for examples.
#
default['deluge']['plugin']['enable'] = []

#
#    manage directory creation
#
# List of directories to create along with the owner and group. This is directly
# related to the core.conf and label.conf files.
#
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
