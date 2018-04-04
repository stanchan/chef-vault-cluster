name 'vault-cluster'
maintainer 'Stan Chan'
maintainer_email 'stanchan@gmail.com'
license 'Apache'
description 'Cookbook which installs and configures a Vault cluster.'
long_description 'Cookbook which installs and configures a Vault cluster.'
version '0.1.0'

recipe 'consul-cluster::default', 'Installs, configures Hashicorp Vault.'

supports 'ubuntu', '>= 12.04'
supports 'redhat', '>= 6.6'
supports 'centos', '>= 6.6'

depends 'consul-cluster', '~> 0.1'
depends 'hashicorp-vault', '~> 2.4'
depends 'deps', '~> 0.5.0'