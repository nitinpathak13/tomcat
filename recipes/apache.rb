#
# Cookbook:: tomcat
# Recipe:: apache
#
# Copyright:: 2020, The Authors, All Rights Reserved.

package 'apache2'

execute 'enable proxy' do
  command 'a2enmod proxy'
  not_if 'a2query -m proxy'
end

execute 'enable http proxy' do
  command 'a2enmod proxy_http'
  not_if 'a2query -m proxy_http'
end

template '/etc/apache2/sites-available/tomcat_manager.conf' do
  source 'tomcat_manager.conf.erb'
end

execute 'enable tomcat conf' do
  command 'a2ensite tomcat_manager.conf'
  action :nothing
  subscribes :run, 'template[/etc/apache2/sites-available/tomcat_manager.conf]', :immediately
end

service 'apache2' do
  action [:enable, :reload, :restart]
end
