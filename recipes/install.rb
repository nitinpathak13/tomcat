#
# Cookbook:: tomcat
# Recipe:: install
#
# Copyright:: 2020, The Authors, All Rights Reserved.

remote_url = node['tomcat']['remote_url']
root = node['tomcat']['root']

# Prerequisites
apt_update
package %w( openjdk-11-jdk nginx)

user 'tomcat' do
  system true
  action :create
end

directory root.to_s

# Download and untar

remote_file "#{Chef::Config[:file_cache_path]}/apache-tomcat-#{node['tomcat']['version']}-fulldocs.tar.gz" do
  source remote_url
  mode '644'
end

execute 'untar downloaded tarball' do
  cwd Chef::Config[:file_cache_path]
  command "tar -xf apache-tomcat-#{node['tomcat']['version']}-fulldocs.tar.gz -C #{root} --strip-components 1"
  not_if { ::File.exist?("#{root}/LICENSE") }
end

execute 'change ownerships' do
  command "chown -R tomcat:tomcat #{root}"
end

systemd_unit 'tomcat.service' do
  content(Unit: {
            Description: 'Apache Tomcat',
            After: 'syslog.target network.target',
          },
          Service: {
            Type: 'forking',
            User: 'tomcat',
            Group: 'tomcat',
            Environment: ['CATALINA_PID=/usr/share/tomcat9/temp/tomcat.pid', 'CATALINA_BASE=/usr/share/tomcat9', 'CATALINA_HOME=/usr/share/tomcat9'],
            ExecStart: '/usr/share/tomcat9/bin/catalina.sh start',
            ExecStop: '/usr/share/tomcat9/bin/catalina.sh stop',

            RestartSec: '12',
            Restart: 'always',
          },
          Install: {
            WantedBy: 'multi-user.target',
          })
  action [:create, :enable]
end
