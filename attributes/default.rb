#
# Cookbook Name:: vault-cluster
# Attributes:: default
#
# Copyright (C) 2017 Stan Chan
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['vault-cluster']['tls']['ssl_key']['source'] = 'data-bag'
default['vault-cluster']['tls']['ssl_key']['bag'] = 'secrets'
default['vault-cluster']['tls']['ssl_key']['item'] = 'vault'
default['vault-cluster']['tls']['ssl_key']['item_key'] = 'private_key'
default['vault-cluster']['tls']['ssl_key']['encrypted'] = false
default['vault-cluster']['tls']['ssl_key']['root'] = join_path config_prefix_path, 'ssl', 'private'
default['vault-cluster']['tls']['ssl_key']['path'] = join_path node['vault-cluster']['tls']['ssl_key']['root'], 'vault.key'

default['vault-cluster']['tls']['ssl_cert']['source'] = 'data-bag'
default['vault-cluster']['tls']['ssl_cert']['bag'] = 'secrets'
default['vault-cluster']['tls']['ssl_cert']['item'] = 'vault'
default['vault-cluster']['tls']['ssl_cert']['item_key'] = 'certificate'
default['vault-cluster']['tls']['ssl_cert']['encrypted'] = false
default['vault-cluster']['tls']['ssl_cert']['root'] = join_path config_prefix_path, 'ssl', 'certs'
default['vault-cluster']['tls']['ssl_cert']['path'] = join_path node['vault-cluster']['tls']['ssl_cert']['root'], 'vault.crt'

default['vault-cluster']['tls']['ssl_chain']['source'] = 'data-bag'
default['vault-cluster']['tls']['ssl_chain']['bag'] = 'secrets'
default['vault-cluster']['tls']['ssl_chain']['item'] = 'vault'
default['vault-cluster']['tls']['ssl_chain']['item_key'] = 'ca'
default['vault-cluster']['tls']['ssl_chain']['root'] = join_path config_prefix_path, 'ssl', 'certs'
default['vault-cluster']['tls']['ssl_chain']['path'] = join_path node['vault-cluster']['tls']['ssl_chain']['root'], 'ca.crt'

default['vault-cluster']['base_url'] = 'https://releases.hashicorp.com/vault'
default['vault-cluster']['binary_url'] = "#{node['vault-cluster']['base_url']}/%{basename}" # rubocop:disable Style/StringLiterals

default['vault-cluster']['listen_port'] = 8200
default['vault-cluster']['backend_type'] = 'consul'
default['vault-cluster']['backend_address'] = '127.0.0.1:8500'