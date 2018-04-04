#
# Cookbook Name:: consul-cluster
# Recipe:: default
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

include_recipe 'consul-cluster::default'

if node['localdev']
  ipaddr = node['network']['interfaces']['ens33']['addresses'].keys[1]
else
  ipaddr = node['ipaddress']
end

deps_hosts 'Update hosts file' do
  action :update
  hostnames node['vault-cluster']['cluster']['hosts']
end

node.override['hashicorp-vault'][node['hashicorp-vault']['version']]['archive_url'] = node['vault-cluster']['binary_url']

node.default['hashicorp-vault']['config']['backend_type'] = 'consul'


poise_service_user node['hashicorp-vault']['service_user'] do
  group node['hashicorp-vault']['service_group']
  not_if { node['hashicorp-vault']['service_user'] == 'root' }
end

directory node['vault-cluster']['tls']['ssl_key']['root'] do
  recursive true
  owner node['hashicorp-vault']['service_user']
  group node['hashicorp-vault']['service_group']
end

directory node['vault-cluster']['tls']['ssl_cert']['root'] do
  recursive true
  owner node['hashicorp-vault']['service_user']
  group node['hashicorp-vault']['service_group']
end

directory node['vault-cluster']['tls']['ssl_chain']['root'] do
  recursive true
  owner node['hashicorp-vault']['service_user']
  group node['hashicorp-vault']['service_group']
end

certificate = ssl_certificate node['hashicorp-vault']['service_name'] do
  owner node['hashicorp-vault']['service_user']
  group node['hashicorp-vault']['service_group']
  namespace node['vault-cluster']['tls']
  notifies :reload, "vault_service[#{name}]", :delayed
end

if node['vault-cluster']['backend_type'] == 'consul'
  node.default['hashicorp-vault']['config']['backend_options']['address'] = node['vault-cluster']['backend_address']
end
node.default['hashicorp-vault']['config']['address'] = "#{ipaddr}:#{node['vault-cluster']['listen_port']}"
node.default['hashicorp-vault']['config']['tls_disable'] = 0
node.default['hashicorp-vault']['config']['tls_cert_file'] = certificate.cert_path
node.default['hashicorp-vault']['config']['tls_key_file'] = certificate.key_path

install = vault_installation node['hashicorp-vault']['version'] do |r|
  if node['hashicorp-vault']['installation']
    node['hashicorp-vault']['installation'].each_pair { |k, v| r.send(k, v) }
  end
end

config = vault_config node['hashicorp-vault']['config']['path'] do |r|
  owner node['hashicorp-vault']['service_user']
  group node['hashicorp-vault']['service_group']

  if node['hashicorp-vault']['config']
    node['hashicorp-vault']['config'].each_pair { |k, v| r.send(k, v) }
  end
  notifies :reload, "vault_service[#{node['hashicorp-vault']['service_name']}]", :delayed
end

vault_service node['hashicorp-vault']['service_name'] do |r|
  user node['hashicorp-vault']['service_user']
  group node['hashicorp-vault']['service_group']
  config_path node['hashicorp-vault']['config']['path']
  disable_mlock config.disable_mlock
  program install.vault_program

  if node['hashicorp-vault']['service']
    node['hashicorp-vault']['service'].each_pair { |k, v| r.send(k, v) }
  end
  action [:enable, :start]
end

