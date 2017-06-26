name 'delugeserver'
maintainer 'Adam Linkous'
maintainer_email 'alinkous+support@gmail.com'
license 'all_rights'
description 'Installs/Configures delugeserver'
long_description 'Installs/Configures delugeserver'
version '2.0.1'
supports 'centos'
chef_version '~> 12.19' if respond_to?(:chef_version)
issues_url 'https://github.com/gryte/delugeserver/issues' if respond_to?(:issues_url)
source_url 'https://github.com/gryte/delugeserver' if respond_to?(:source_url)

depends 'firewall', '~> 2.6.1'
